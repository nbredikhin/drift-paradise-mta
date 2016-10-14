MapIcons = {}
local PLAYER_ICON_SIZE = 17
local PLAYER_NAME_OFFSET = 6
local PLAYER_NAME_SCALE = 1.5

local BLIP_SIZE = 20
local BLIP_NAME_OFFSET = 10
local BLIP_NAME_SCALE = 1.9
local textures = {}
local cameraHeightMul = 0
local themePrimaryColor = {255, 255, 255}

local function drawPlayer(player)
	local x, y, z = getElementPosition(player)
	x, y, z = MapWorld.convertPositionToMap(x, y, z)
	x, y = getScreenFromWorldPosition(x, y, z)
	if x then
		local playerName = exports.dpUtils:removeHexFromString(player.name)
		local textX, textY = x, y - PLAYER_ICON_SIZE - PLAYER_NAME_OFFSET
		local r, g, b = themePrimaryColor[1], themePrimaryColor[2], themePrimaryColor[3]
		if player.vehicle then
			local color = player.vehicle:getData("BodyColor")
			if color then 
				r, g, b = unpack(color)
			end
		end		
		dxDrawText(
			playerName, 
			textX + 1, textY + 1, 
			textX + 1, textY + 1, 
			tocolor(0, 0, 0, 200 * cameraHeightMul), 
			PLAYER_NAME_SCALE, 
			"default", "center", "center"
		)		
		dxDrawText(
			playerName, 
			textX, textY, 
			textX, textY, 
			tocolor(r, g, b, 255 * cameraHeightMul), 
			PLAYER_NAME_SCALE, 
			"default", "center", "center"
		)
		-- Стрелка
		dxDrawImage(
			x - PLAYER_ICON_SIZE / 2, 
			y - PLAYER_ICON_SIZE / 2, 
			PLAYER_ICON_SIZE, PLAYER_ICON_SIZE, 
			textures.player, 
			player.rotation.z, 0, 0,
			tocolor(r, g, b, 255 - 255 * cameraHeightMul)
		)
		-- Круг
		dxDrawImage(
			x - PLAYER_ICON_SIZE / 2, 
			y - PLAYER_ICON_SIZE / 2, 
			PLAYER_ICON_SIZE, PLAYER_ICON_SIZE, 
			textures.blip, 
			0, 0, 0,
			tocolor(r, g, b, 255 * cameraHeightMul)
		)		
	end
end

local function drawBlip(blip)
	if blip:getData("hiddenOnWorldMap") then
		return
	end
	local x, y, z = getElementPosition(blip)
	x, y, z = MapWorld.convertPositionToMap(x, y, z)
	x, y = getScreenFromWorldPosition(x, y, z)
	if x then
		local textX, textY = x, y - BLIP_SIZE - BLIP_NAME_OFFSET
		local blipText = blip:getData("text")
		if blipText then
			blipText = exports.dpLang:getString(blipText)
			dxDrawText(
				blipText, 
				textX + 1, textY + 1, 
				textX + 1, textY + 1, 
				tocolor(0, 0, 0, 200 * cameraHeightMul), 
				BLIP_NAME_SCALE, 
				"default", "center", "center"
			)		
			dxDrawText(
				blipText, 
				textX, textY, 
				textX, textY, 
				tocolor(255, 255, 255, 255 * cameraHeightMul), 
				BLIP_NAME_SCALE, 
				"default", "center", "center"
			)
		end
		dxDrawImage(
			x - BLIP_SIZE / 2, 
			y - BLIP_SIZE / 2, 
			BLIP_SIZE, BLIP_SIZE, 
			textures.blip, 
			0, 0, 0,
			tocolor(255, 255, 255)
		)
	end
end

function MapIcons.start()
	textures.player = dxCreateTexture("assets/icons/player.png")
	textures.blip = dxCreateTexture("assets/icons/blip.png")
	themePrimaryColor = {exports.dpUI:getThemeColor()}
end

function MapIcons.stop()
	for name, texture in pairs(textures) do
		if isElement(texture) then
			destroyElement(texture)
		end
	end
	textures = {}
end

function MapIcons.draw()
	local cameraHeight = MapCamera.getHeight()
	if cameraHeight < 12 then
		cameraHeightMul = math.min(1, (1 - (cameraHeight- 5) / 7))
	else
		cameraHeightMul = 0
	end

	-- Иконки игроков
	for i, player in ipairs(getElementsByType("player")) do
		local pos = player.position
		drawPlayer(player)
	end

	-- Блипы
	for i, blip in ipairs(getElementsByType("blip")) do
		drawBlip(blip)
	end
end