TuningCamera = {}
-- Точка, в которой находится камера
local currentCameraPosition = Vector3()
local targetCameraPosition = Vector3()
local cameraMovingSpeed = 10
-- Точка, в которую смотрит камера
local currentCameraLookPosition = Vector3()
local targetCameraLookPosition = Vector3()
local cameraLookMovingSpeed = 20
-- Field of View
local DEFAULT_CAMERA_FOV = 50
local currentCameraFOV = DEFAULT_CAMERA_FOV
local targetCameraFOV = DEFAULT_CAMERA_FOV
local cameraFOVSpeed = 50
-- Поворот камеры
local DEFAULT_CAMERA_ROLL = 0
local currentCameraRoll = DEFAULT_CAMERA_ROLL
local targetCameraRoll = DEFAULT_CAMERA_ROLL
local cameraRollSpeed = 20

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
	local shakeY = math.cos(getTickCount() / 250) * (math.sin(getTickCount() / 300) + 1) * 0.01
	local shakeZ = math.sin(getTickCount() / 430) * (math.cos(getTickCount() / 600) + 1) * 0.01
	local cameraShakeOffset = Vector3(shakeX, shakeY, shakeZ)	

	-- Обновление позиции камеры
	Camera.setMatrix(
		currentCameraPosition + cameraShakeOffset / 2, 
		currentCameraLookPosition - cameraShakeOffset,
		currentCameraRoll,
		currentCameraFOV
	)
end

function TuningCamera.start()
	targetCameraPosition = localPlayer.vehicle.position + Vector3(8, 0, 2)
	currentCameraPosition = targetCameraPosition
	targetCameraLookPosition = localPlayer.vehicle.position
	currentCameraLookPosition = targetCameraLookPosition

	addEventHandler("onClientPreRender", root, update)
end

function TuningCamera.stop()
	removeEventHandler("onClientPreRender", root, update)
	-- Сброс камеры
	setCameraTarget(localPlayer)
end