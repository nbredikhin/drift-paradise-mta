IntroCutscene = {}
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
end

local function gotoState3()
	currentCameraPosition = Vector3 { x = 454.279, y = -1722.245, z = 9.595 }
	targetCameraPosition = Vector3 { x = 454.279, y = -1722.245, z = 11.295 }
	currentCameraLookPosition = Vector3 { x = 467.110, y = -1723.612, z = 9.657 }
	targetCameraLookPosition = Vector3 { x = 467.110, y = -1723.612, z = 11.657 }
	cameraMovingSpeed = 0.1
	cameraLookMovingSpeed = 0.1	

	currentCameraFOV = 40
	targetCameraFOV = currentCameraFOV	

	setTimer(function ()
		fadeCamera(false, 1)
		setTimer(function ()
			IntroCutscene.stop()			
			fadeCamera(true, 1)
		end, 1000, 1)
	end, 5000, 1)	
end

local function gotoState2()
	currentCameraPosition = Vector3 { x = 383.780, y = -1716.867, z = 7.670 }
	targetCameraPosition = Vector3 { x = 424.705, y = -1717.430, z = 9.401 }
	currentCameraLookPosition = Vector3 { x = 424.705, y = -1717.430, z = 9.401 }
	targetCameraLookPosition = Vector3 { x = 469.192, y = -1722.976, z = 10.736 }
	cameraMovingSpeed = 0.1
	cameraLookMovingSpeed = 0.1

	setTimer(function ()
		fadeCamera(false, 1)
		setTimer(function ()
			gotoState3()
			fadeCamera(true, 1)
		end, 1000, 1)
	end, 7000, 1)
end

function IntroCutscene.start()
	fadeCamera(false, 0)
	setTimer(function ()
		fadeCamera(true, 6)
	end, 100, 1)
	addEventHandler("onClientPreRender", root, update)

	currentCameraPosition = Vector3 { x = 2730.016, y = -1974.242, z = 171.960 }
	targetCameraPosition = Vector3 { x = 1919.868, y = -1478.711, z = 102.902 } 
	currentCameraLookPosition = Vector3 { x = 2730.016, y = -1974.242, z = 0 }
	targetCameraLookPosition = Vector3 { x = 1741.631, y = -1357.284, z = 129.665 }
	cameraMovingSpeed = 0.1
	cameraLookMovingSpeed = 0.086

	setTimer(function()
		fadeCamera(false, 1)
		setTimer(function ()
			gotoState2()
			fadeCamera(true, 1)
		end, 1000, 1)
	end, 23000, 1)
end

function IntroCutscene.stop()
	removeEventHandler("onClientPreRender", root, update)
	setCameraTarget(localPlayer)
end