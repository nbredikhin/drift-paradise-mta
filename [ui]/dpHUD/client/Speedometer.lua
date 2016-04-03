Speedometer = {}
Speedometer.visible = true
local DRAW_POST_GUI = false
local MAX_SPEED = 220
local SPEED_SECTORS_COUNT = 88
local SIDEBAR_SECTORS_COUNT = 13

local screenWidth, screenHeight = guiGetScreenSize()
local originalSize = 400
local width, height = Utils.sceenScale(250), Utils.sceenScale(250)
local screenOffset = Utils.sceenScale(20)

local fallbackTo2d = false

local textureShader
local renderTarget

local font

local function getCarSpeed()
	if not localPlayer.vehicle then
		return 0
	end
	return math.floor(localPlayer.vehicle.velocity:getLength() * 180)
end

local function getCarSpeedString()
	local speed = getCarSpeed()
	if speed < 100 then
		if speed < 10 then
			speed = "00" .. tostring(speed)
		else
			speed = "0" .. tostring(speed)
		end
	else
		speed = tostring(speed)
	end
	return speed
end

local function drawSpeedometer(x, y, width, height)
	-- Круг скорости
	dxDrawImage(x, y, width, height, "assets/textures/speedometer/circle.png")
	local sectorsCount = math.min(SPEED_SECTORS_COUNT, getCarSpeed() / MAX_SPEED * SPEED_SECTORS_COUNT)
	for i = 1, sectorsCount do
		local rotation = (i - 1) * 3
		dxDrawImage(x, y, width, height, "assets/textures/speedometer/circle2.png", rotation)
	end
	dxDrawImage(x, y, width, height, "assets/textures/speedometer/numbers.png")

	-- hp
	dxDrawImage(x, y, width, height, "assets/textures/speedometer/hpfull.png")
	if localPlayer.vehicle then
		sectorsCount = localPlayer.vehicle.health / 1000 * SIDEBAR_SECTORS_COUNT
		for i = 1, sectorsCount do
			local rotation = -(i - 1) * 6.8
			dxDrawImage(x, y, width, height, "assets/textures/speedometer/hp.png", rotation)
		end
	end
	-- nitro
	dxDrawImage(x, y, width, height, "assets/textures/speedometer/nitrofull.png")

	-- Скорость
	dxDrawImage(x, y, width, height, "assets/textures/speedometer/3.png")
	dxDrawText(getCarSpeedString(), x, y, x + width, y + height, tocolor(255, 255, 255, 160), 1, font, "center", "bottom")

	-- Иконки
	dxDrawImage(x, y, width, height, "assets/textures/speedometer/icons.png")
end

addEventHandler("onClientRender", root, function ()
	if not localPlayer.vehicle then
		return
	end	
	if fallbackTo2d then
		drawSpeedometer(screenWidth - width - screenOffset, screenHeight - height - screenOffset, width, height)
	else
		-- Отрисовка спидометра в renderTarget
		dxSetRenderTarget(renderTarget, true)
		drawSpeedometer(0, 0, originalSize, originalSize)
		dxSetRenderTarget()

		textureShader:setValue("sPicTexture", renderTarget)
		
		dxDrawImage(
			screenWidth - width - screenOffset,
			screenHeight - height - screenOffset, 
			width, 
			height,
			textureShader, 
			0, 0, 0, 
			tocolor(255, 255, 255, 255), 
			DRAW_POST_GUI
		)
	end
end)

function Speedometer.start()
	if renderTarget then
		return false
	end
	font = dxCreateFont("assets/fonts/speed.ttf", 90, false)
	renderTarget = dxCreateRenderTarget(originalSize, originalSize, false)
	textureShader = exports.dpAssets:createShader("texture3d.fx")
	if not (renderTarget and textureShader) then
		fallbackTo2d = true
		outputDebugString("Speedometer: Fallback to 2d")
		return
	end
end

function Speedometer.setRotation(x, y, z)
	if not x or not y then
		return false
	end
	if not z then
		z = 0
	end
	if not textureShader then
		return false
	end
	dxSetShaderTransform(textureShader, x, y, z)
end