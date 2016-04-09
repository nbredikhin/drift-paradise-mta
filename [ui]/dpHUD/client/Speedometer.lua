Speedometer = {}
Speedometer.visible = true
local DRAW_POST_GUI = false
local MAX_SPEED = 220
local SPEED_SECTORS_COUNT = 134

local screenWidth, screenHeight = guiGetScreenSize()
local originalSize = 400
local width, height = Utils.sceenScale(250), Utils.sceenScale(250)
local screenOffset = Utils.sceenScale(20)

local fallbackTo2d = false

local textureShader
local renderTarget
local maskShader

local circleTextures = {}
local imageIndexPrev = 0

local font

local function getVehicleSpeed()
	if not localPlayer.vehicle then
		return 0
	end
	return math.floor(localPlayer.vehicle.velocity:getLength() * 180)
end

local function getVehicleSpeedString()
	local speed = getVehicleSpeed()
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
	dxDrawImage(x, y, width, height, "assets/textures/speedometer/circle.png", 0, 0, 0, tocolor(255, 255, 255, 200))
	local speed = getVehicleSpeed()
	--[[local sectorsCount = math.min(SPEED_SECTORS_COUNT, speed / MAX_SPEED * SPEED_SECTORS_COUNT)
	for i = 1, sectorsCount do
		local rotation = (i - 1) * 2
		dxDrawImage(x, y, width, height, "assets/textures/speedometer/circle2.png", rotation)
	end]]
	local angle = math.max(-270, -speed * 2)
	local imageIndex = math.min(math.floor(-angle / 90) + 1, 3)
	angle = angle + 90 * (imageIndex - 1)
	if imageIndexPrev ~= imageIndex then
		maskShader:setValue("sPicTexture", circleTextures[imageIndex])
		imageIndexPrev = imageIndex
	end
	maskShader:setValue("gUVRotAngle", math.rad(angle))
	dxDrawImage(x, y, width, height, maskShader)
	dxDrawImage(x, y, width, height, "assets/textures/speedometer/numbers.png")

	-- Скорость
	local gear = getVehicleCurrentGear(localPlayer.vehicle)
	if gear == 0 then
		gear = "R"
	end
	if speed == 0 then
		gear = "N"
	end
	dxDrawImage(x, y, width, height, "assets/textures/speedometer/" .. gear ..".png")
	dxDrawText(getVehicleSpeedString(), x, y, x + width, y + height, tocolor(255, 255, 255, 255), 1, font, "center", "bottom")
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
			tocolor(255, 255, 255, 200), 
			DRAW_POST_GUI
		)
	end
end)

function Speedometer.start()
	if renderTarget then
		return false
	end
	font = dxCreateFont("assets/fonts/speed.ttf", 90, false)
	renderTarget = dxCreateRenderTarget(originalSize, originalSize, true)
	textureShader = exports.dpAssets:createShader("texture3d.fx")
	maskShader = exports.dpAssets:createShader("mask3d.fx")
	local maskTexture = dxCreateTexture("assets/textures/speedometer/mask.png")
	for i = 1, 3 do
		circleTextures[i] = dxCreateTexture("assets/textures/speedometer/circle"..tostring(i)..".png")
	end
	maskShader:setValue("sMaskTexture", maskTexture)
	maskShader:setValue("gUVRotCenter", 0.5, 0.5)
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