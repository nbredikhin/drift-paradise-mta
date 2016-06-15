Radar = {}
Radar.visible = false
local DRAW_POST_GUI = false
local screenWidth, screenHeight = guiGetScreenSize()

local width, height = Utils.screenScale(250), Utils.screenScale(250)
local screenOffset = Utils.screenScale(20)
local WORLD_SIZE = 3072
local CHUNK_SIZE = 256
local CHUNKS_COUNT = 12
local SCALE_FACTOR = 2
local arrowSize = 25
local playerTextureSize = 25

local maskShader
local renderTarget
local maskTexture
local mapTexture

local arrowTexture
local playerTexture

local scale = 5
local fallbackTo2d = true
local camera

local chunkRenderSize = CHUNK_SIZE * scale / SCALE_FACTOR
local chunksTextures = {}

local players = {}

local function drawRadarChunk(x, y, chunkX, chunkY)
	local chunkID = chunkX + chunkY * CHUNKS_COUNT
	if chunkID < 0 or chunkID > 143 or chunkX >= CHUNKS_COUNT or chunkY >= CHUNKS_COUNT or chunkX < 0 or chunkY < 0 then
		return
	end
	
	local posX, posY = ((x - (chunkX) * CHUNK_SIZE) / CHUNK_SIZE) * chunkRenderSize, 
				       ((y - (chunkY) * CHUNK_SIZE) / CHUNK_SIZE) * chunkRenderSize 
	dxDrawImage(width / 2 - posX, width / 2 - posY, chunkRenderSize, chunkRenderSize, chunksTextures[chunkID])
end

local function drawRadarSection(x, y)
	local chunkX = math.floor(x / CHUNK_SIZE)
	local chunkY = math.floor(y / CHUNK_SIZE)

	drawRadarChunk(x, y, chunkX - 1, chunkY)
	drawRadarChunk(x, y, chunkX, chunkY)
	drawRadarChunk(x, y, chunkX + 1, chunkY)

	drawRadarChunk(x, y, chunkX - 1, chunkY - 1)
	drawRadarChunk(x, y, chunkX, chunkY - 1)
	drawRadarChunk(x, y, chunkX + 1, chunkY - 1)	

	drawRadarChunk(x, y, chunkX - 1, chunkY + 1)
	drawRadarChunk(x, y, chunkX, chunkY + 1)
	drawRadarChunk(x, y, chunkX + 1, chunkY + 1)
end

local function drawPlayers()
	for player in pairs(players) do
		if player ~= localPlayer then

			local color = tocolor(255, 255, 255, 255)
			if player.vehicle then
				color = player.vehicle:getData("BodyColor")
				if color then 
					color = tocolor(unpack(color))
				end
			end
			-- color = tocolor(123, 0, 123)
			Radar.drawImageOnMap(player.position.x, player.position.y, player.rotation.z, 
				playerTexture, playerTextureSize, playerTextureSize, color)
		end
	end
end

local function drawRadar()
	local x = (localPlayer.position.x + 3000) / 6000 * WORLD_SIZE
	local y = (-localPlayer.position.y + 3000) / 6000 * WORLD_SIZE

	local sectionX = x
	local sectionY = y
	drawRadarSection(sectionX, sectionY)
	drawPlayers()
	local color = tocolor(255, 255, 255)
	if localPlayer.vehicle then 
	    color = localPlayer.vehicle:getData("BodyColor")
	    if color then 
		color = tocolor(unpack(color))
	    else
		color = tocolor(255, 255, 255)
	    end
	end
	dxDrawImage(
		(width - arrowSize) / 2, 
		(height - arrowSize) / 2, 
		arrowSize, 
		arrowSize,
		arrowTexture,
		-localPlayer.rotation.z,
		0,
		0,
		color
	)
	-- Пример использования:
	-- Radar.drawImageOnMap(700, 900, 0, arrowTexture, 
		-- arrowSize, arrowSize, 
		-- tocolor(16, 160, 207))

	drawPlayers()
end

addEventHandler("onClientRender", root, function ()
	if not Radar.visible then
		return
	end
	if not fallbackTo2d then	
		-- Отрисовка радара в renderTarget
		dxSetRenderTarget(renderTarget, true)
		drawRadar()
		dxSetRenderTarget()

		-- Следование за игроком
		maskShader:setValue("gUVRotAngle", -math.rad(camera.rotation.z))
		maskShader:setValue("gUVPosition", 0, 0)
		maskShader:setValue("gUVScale", 1, 1)
		maskShader:setValue("sPicTexture", renderTarget)
		maskShader:setValue("sMaskTexture", maskTexture)

		dxDrawImage(
			screenOffset,
			screenHeight - height - screenOffset, 
			width, 
			height,
			maskShader, 
			0, 0, 0, 
			tocolor(255, 255, 255, 255), 
			DRAW_POST_GUI
		)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "player" then
		players[source] = true
	end 
end)

addEventHandler("onClientElementStreamOut", root, function()
	if source.type == "player" then
		players[source] = nil
	end 
end)

addEventHandler("onClientPlayerJoin", root, function()
	players[source] = true
end)

addEventHandler("onClientPlayerQuit", root, function()
	players[source] = nil
end)

function Radar.start()
	if renderTarget then
		return false
	end
	renderTarget = dxCreateRenderTarget(width, height, true)
	maskShader = exports.dpAssets:createShader("mask3d.fx")
	fallbackTo2d = false
	if not (renderTarget and maskShader) then
		fallbackTo2d = true
		outputDebugString("Radar: Failed to create renderTarget or shader")
		return
	end
	maskTexture = dxCreateTexture("assets/textures/radar/mask.png")
	mapTexture = dxCreateTexture("assets/textures/radar/map.png", "argb", true, "clamp")
	maskShader:setValue("gUVRotCenter", 0.5, 0.5)
	maskShader:setValue("sMaskTexture", maskTexture)
	for i = 0, 143 do
		chunksTextures[i] = dxCreateTexture("assets/textures/radar/map/radar" .. i .. ".png", "argb", true, "clamp")
	end
	camera = getCamera()
	arrowTexture = DxTexture("assets/textures/radar/arrow.png")
	playerTexture = DxTexture("assets/textures/radar/arrow.png")
	players = {}
	for i,v in ipairs(getElementsByType("player")) do
		if isElementStreamedIn(v) then 
			players[v] = true
		end
	end
end

function Radar.setRotation(x, y, z)
	if not x or not y then
		return false
	end
	if not z then
		z = 0
	end
	if not maskShader then
		return false
	end
	dxSetShaderTransform(maskShader, x, y, z)
end

function Radar.setVisible(visible)
	Radar.visible = not not visible
end

function Radar.drawImageOnMap(globalX, globalY, rotationZ, image, imgWidth, imgHeight, color)
	local relativeX, relativeY = localPlayer.position.x - globalX,
								 localPlayer.position.y - globalY
	local mapX, mapY = 	relativeX / 6000 * WORLD_SIZE * scale / SCALE_FACTOR, 
						relativeY / 6000 * WORLD_SIZE * scale / SCALE_FACTOR
 
	local distance = mapX * mapX + mapY * mapY
	-- Картинка слишком далеко от игрока, нет смысла рисовать
	if distance > chunkRenderSize * chunkRenderSize * 9 then
		return
	end
	dxDrawImage((width -  imgWidth) / 2 - mapX, 
				(height - imgHeight) / 2 + mapY, imgWidth, imgHeight, image,
				 -rotationZ, 0, 0, color)
end