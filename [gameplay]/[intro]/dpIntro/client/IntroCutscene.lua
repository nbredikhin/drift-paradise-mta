IntroCutscene = {}
local screenWidth, screenHeight = guiGetScreenSize()

-- Точка, в которой находится камера
local currentCameraPosition = Vector3()
local targetCameraPosition = Vector3()
local cameraMovingSpeed = 0.1
-- Точка, в которую смотрит камера
local currentCameraLookPosition = Vector3()
local targetCameraLookPosition = Vector3()
local cameraLookMovingSpeed = 0.086
-- Field of View
local DEFAULT_CAMERA_FOV = 50
local currentCameraFOV = DEFAULT_CAMERA_FOV
local targetCameraFOV = DEFAULT_CAMERA_FOV
local cameraFOVSpeed = 2
-- Поворот камеры
local DEFAULT_CAMERA_ROLL = 0
local currentCameraRoll = DEFAULT_CAMERA_ROLL
local targetCameraRoll = DEFAULT_CAMERA_ROLL
local cameraRollSpeed = 20

local logoTexture
local logoWidth, logoHeight
local logoAnim = 0
local logoAnimTarget = 0
local textAnim = 0
local textAnimTarget = 0
local bgAnim = 0
local bgAnimTarget = 0

local font

local function update(deltaTime)
	deltaTime = deltaTime / 1000
	-- Плавное движение камеры в заданную точку
	currentCameraPosition = currentCameraPosition + 
		(targetCameraPosition - currentCameraPosition) * cameraMovingSpeed * deltaTime
	currentCameraLookPosition = currentCameraLookPosition + 
		(targetCameraLookPosition - currentCameraLookPosition) * cameraLookMovingSpeed * deltaTime
	currentCameraFOV = currentCameraFOV + (targetCameraFOV - currentCameraFOV) * cameraFOVSpeed * deltaTime
	currentCameraRoll = currentCameraRoll + (targetCameraRoll - currentCameraRoll) * cameraRollSpeed * deltaTime

	-- Реалистичная тряска камеры
	local shakeX = math.sin(getTickCount() / 740) * (math.sin(getTickCount() / 300) + 1) * 0.01
	local shakeY = math.cos(getTickCount() / 550) * (math.sin(getTickCount() / 300) + 1) * 0.01
	local shakeZ = math.sin(getTickCount() / 430) * (math.cos(getTickCount() / 600) + 1) * 0.03
	local cameraShakeOffset = Vector3(shakeX, shakeY, shakeZ)	

	-- Обновление позиции камеры
	Camera.setMatrix(
		currentCameraPosition - cameraShakeOffset / 4, 
		currentCameraLookPosition + cameraShakeOffset,
		currentCameraRoll,
		currentCameraFOV
	)

	logoAnim = logoAnim + (logoAnimTarget - logoAnim) * deltaTime * 0.5
	textAnim = textAnim + (textAnimTarget - textAnim) * deltaTime * 2
	bgAnim = bgAnim + (bgAnimTarget - bgAnim) * deltaTime * 0.2
end

local function draw()
	dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 54, 56, 230 * bgAnim))
	local w = logoWidth * (logoAnim * 0.1 + 0.9)
	local h = logoHeight * (logoAnim * 0.1 + 0.9)
	dxDrawImage(
		screenWidth / 2 - w / 2, 
		screenHeight * 0.55 - h / 2, 
		w, 
		h, 
		logoTexture,
		0, 0, 0,
		tocolor(255, 255, 255, 255 * logoAnim))

	dxDrawText("Нажмите ПРОБЕЛ, чтобы продолжить", 
		0, screenHeight * 0.45, screenWidth, screenHeight - 100,
		tocolor(255, 255, 255, 255 * textAnim),
		1, font,
		"center", "bottom")
end

local function preLogo()
	cameraFOVSpeed = 0.1
	targetCameraFOV = 40
	bgAnimTarget = 1
end

local function showLogo()
	logoAnimTarget = 1
	cameraFOVSpeed = 2
	targetCameraFOV = 60

	setTimer(function ()
		textAnimTarget = 1
	end, 2500, 1)
end

function IntroCutscene.start()

	logoTexture = exports.dpAssets:createTexture("logo_red.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	logoWidth = screenWidth * 0.6
	logoHeight = logoWidth

	font = exports.dpAssets:createFont("Roboto-Regular.ttf", 18)

	exports.dpTime:restoreTime()
	exports.dpTime:forceTime(0, 0)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientRender", root, draw)

	currentCameraPosition = Vector3 { x =  558.043, y = -966.229, z = 106.204 }
	targetCameraPosition = Vector3 { x = 1141.950, y = -1092.399, z = 60.909 } 
	currentCameraLookPosition = Vector3 { x =  558.043, y = -966.229, z = 0 }
	targetCameraLookPosition = Vector3 { x = 1447.834, y = -1160.533, z = 109.864  }
	cameraMovingSpeed = 0.2
	cameraLookMovingSpeed = 0.2

	bindKey("space", "down", IntroCutscene.stop)

	setTimer(preLogo, 18000, 1)
	setTimer(showLogo, 22000, 1)
end

function IntroCutscene.stop()
	unbindKey("space", "down", IntroCutscene.stop)
	exports.dpTime:restoreTime()
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientRender", root, draw)
	setCameraTarget(localPlayer)

	if isElement(logoTexture) then
		destroyElement(logoTexture)
	end

	if isElement(font) then
		destroyElement(font)
	end
end