Radar = {}
Radar.visible = true
local DRAW_POST_GUI = false
local screenWidth, screenHeight = guiGetScreenSize()

local width, height = Utils.sceenScale(250), Utils.sceenScale(250)
local screenOffset = Utils.sceenScale(20)
local worldWidth, worldHeight = 3072, 3072
local arrowSize = 25

local maskShader
local renderTarget
local maskTexture
local mapTexture

local zoom = 10
local fallbackTo2d = true
local camera

local function drawRadar()
	local x = (localPlayer.position.x + 3000) / 6000 * worldWidth
	local y = (-localPlayer.position.y + 3000) / 6000 * worldHeight

	local sectionWidth = worldWidth / zoom
	local sectionHeight = worldHeight / zoom
	local sectionX = x - sectionWidth / 2
	local sectionY = y - sectionHeight / 2
	dxDrawImageSection(
		0, 0, 
		width, height, 
		sectionX, sectionY, 
		sectionWidth, sectionHeight, 
		mapTexture, 
		camera.rotation.z, 0, 0, 
		tocolor(255, 255, 255, 255)
	)
	-- dxDrawImage(
	-- 	(worldWidth - arrowSize) / 2, 
	-- 	(worldHeight - arrowSize) / 2, 
	-- 	arrowSize, 
	-- 	arrowSize,
	-- 	"assets/textures/radar/arrow.png",
	-- 	-localPlayer.rotation.z
	-- )
end

addEventHandler("onClientRender", root, function ()
	if not fallbackTo2d then	
		-- Отрисовка радара в renderTarget
		dxSetRenderTarget(renderTarget, true)
		drawRadar()
		dxSetRenderTarget()

		-- Следование за игроком
		maskShader:setValue("gUVRotAngle", 0)
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
	camera = getCamera()
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