MapIcons = {}
local ICON_SIZE = 20
local PLAYER_NAME_OFFSET = 10
local PLAYER_NAME_SCALE = 1.8
local textures = {}
local cameraHeightMul = 0
local themePrimaryColor = {255, 255, 255}

local function drawPlayerIcon(playerName, x, y, z, rotation)
	x, y, z = MapWorld.convertPositionToMap(x, y, z)
	x, y = getScreenFromWorldPosition(x, y, z)
	if x then
		local textX, textY = x, y - ICON_SIZE - PLAYER_NAME_OFFSET
		dxDrawText(
			playerName, 
			textX + 2, textY + 2, 
			textX + 2, textY + 2, 
			tocolor(0, 0, 0, 200 * cameraHeightMul), 
			PLAYER_NAME_SCALE, 
			"default", "center", "center"
		)		
		dxDrawText(
			playerName, 
			textX, textY, 
			textX, textY, 
			tocolor(themePrimaryColor[1], themePrimaryColor[2], themePrimaryColor[3], 255 * cameraHeightMul), 
			PLAYER_NAME_SCALE, 
			"default", "center", "center"
		)
		dxDrawImage(
			x - ICON_SIZE / 2, 
			y - ICON_SIZE / 2, 
			ICON_SIZE, ICON_SIZE, 
			textures.player, 
			0, 0, 0,
			tocolor(themePrimaryColor[1], themePrimaryColor[2], themePrimaryColor[3])
		)
	end
end

local function drawBlip()

end

function MapIcons.start()
	textures.player = dxCreateTexture("assets/icons/player.png")
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
		drawPlayerIcon(exports.dpUtils:removeHexFromString(player.name), pos.x, pos.y, pos.z, player.rotation.z)
	end
end