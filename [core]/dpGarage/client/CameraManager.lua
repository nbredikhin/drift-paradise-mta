CameraManager = {}

local ANIMATION_SPEED = 2
local currentAnimationSpeed = ANIMATION_SPEED
local currentCameraState
local MOUSE_LOOK_SPEED = 50
local mouseLookEnabled = false
local MOUSE_LOOK_VERTICAL_MAX = 45
local MOUSE_LOOK_VERTICAL_MIN = -3

local MOUSE_LOOK_DISTANCE_DELTA = 0.5
local MOUSE_LOOK_DISTANCE_MIN = 4
local MOUSE_LOOK_DISTANCE_MAX = 6.5

local camera = {
	rotationHorizontal = 0,
	rotationVertical = 0,
	distance = 5,
	FOV = 70,
	targetPosition = Vector3(),
	roll = 0
}
local targetCamera = {}
local oldCameraState 

local function update(deltaTime)
	deltaTime = deltaTime / 1000

	for k, v in pairs(targetCamera) do
		if k == "rotationHorizontal" then
			local diff = exports.dpUtils:differenceBetweenAngles(camera[k], targetCamera[k])
			camera[k] = camera[k] + diff * deltaTime * currentAnimationSpeed
		else
			camera[k] = camera[k] + (targetCamera[k] - camera[k]) * deltaTime * currentAnimationSpeed
		end
	end

	local shakeX = math.sin(getTickCount() / 740) * (math.sin(getTickCount() / 300) + 1) * 0.002
	local shakeY = math.cos(getTickCount() / 250) * (math.sin(getTickCount() / 300) + 1) * 0.0005
	local shakeZ = math.sin(getTickCount() / 430) * (math.cos(getTickCount() / 600) + 1) * 0.002
	local shakeOffset = Vector3(shakeX, shakeY, shakeZ)

	local pitch = math.rad(camera.rotationVertical)
	local yaw = math.rad(camera.rotationHorizontal)
	local cameraOffset = Vector3(math.cos(yaw) * math.cos(pitch), math.sin(yaw) * math.cos(pitch), math.sin(pitch))
	cameraOffset = cameraOffset + shakeOffset / 8
	local works = Camera.setMatrix(
		camera.targetPosition + cameraOffset * camera.distance, 
		camera.targetPosition - shakeOffset * 4, 
		camera.roll, 
		camera.FOV
	)

	--outputDebugString("currentCameraState: " .. tostring(currentCameraState))
	camera.rotationHorizontal = exports.dpUtils:wrapAngle(camera.rotationHorizontal)
end

function CameraManager.setState(name, noAnimation, animationSpeed)
	if not noAnimation and type(animationSpeed) == "number" then
		currentAnimationSpeed = animationSpeed
	else
		currentAnimationSpeed = ANIMATION_SPEED
	end
	local vehicle = GarageCar.getVehicle()
	local vehicleMatrix = vehicle.matrix
	for k, v in pairs(cameraPresets[name]) do
		if k == "targetPosition" then
			if type(v) == "string" then
				if v == "car" then				
					targetCamera.targetPosition = Vector3(GarageCar.getVehicle().position)
				else
					local componentOffset = Vector3(vehicle:getComponentPosition(v))
					targetCamera.targetPosition = vehicleMatrix:transformPosition(componentOffset)
				end
			else
				vehicle = GarageCar.getVehicle()
				targetCamera.targetPosition = vehicleMatrix:transformPosition(v)
			end
			if noAnimation then
				camera.targetPosition = Vector3(targetCamera.targetPosition)
			end
		else
			if k == "rotationHorizontal" then
				v = exports.dpUtils:wrapAngle(v)
			end
			targetCamera[k] = v
			if noAnimation then
				camera[k] = v
			end
		end
	end
	currentCameraState = name
end

local function mouseMove(x, y)
	if not mouseLookEnabled then
		return
	end
	local mx = x - 0.5
	local my = y - 0.5
	targetCamera.rotationHorizontal = targetCamera.rotationHorizontal - mx * MOUSE_LOOK_SPEED
	targetCamera.rotationVertical = targetCamera.rotationVertical + my * MOUSE_LOOK_SPEED
	
	if targetCamera.rotationVertical > MOUSE_LOOK_VERTICAL_MAX then
		targetCamera.rotationVertical = MOUSE_LOOK_VERTICAL_MAX 
	elseif targetCamera.rotationVertical < MOUSE_LOOK_VERTICAL_MIN then
		targetCamera.rotationVertical = MOUSE_LOOK_VERTICAL_MIN
	end
end

local function handleKey(key, down)
	if not down then
		return
	end
	if currentCameraState == "freeLookCamera" then
		if key == "mouse_wheel_down" then
			targetCamera.distance = targetCamera.distance + MOUSE_LOOK_DISTANCE_DELTA
			if targetCamera.distance > MOUSE_LOOK_DISTANCE_MAX then
				targetCamera.distance = MOUSE_LOOK_DISTANCE_MAX
			end
		elseif key == "mouse_wheel_up" then
			targetCamera.distance = targetCamera.distance - MOUSE_LOOK_DISTANCE_DELTA
			if targetCamera.distance < MOUSE_LOOK_DISTANCE_MIN then
				targetCamera.distance = MOUSE_LOOK_DISTANCE_MIN
			end
		end
	end
end

local function startMouseLook()
	if mouseLookEnabled or isMTAWindowActive() then
		return
	end
	mouseLookEnabled = true
	oldCameraState = currentCameraState
	local rotationHorizontal = camera.rotationHorizontal
	local rotationVertical = camera.rotationVertical
	local distance = false
	if currentCameraState == "freeLookCamera" then
		distance = targetCamera.distance
	end
	CameraManager.setState("freeLookCamera", false, 5)
	if distance then
		targetCamera.distance = distance
	end
	camera.rotationHorizontal = rotationHorizontal
	camera.rotationVertical = rotationVertical
	targetCamera.rotationHorizontal = rotationHorizontal
	targetCamera.rotationVertical = rotationVertical	
	if oldCameraState ~= "freeLookCamera" then	
		GarageUI.setVisible(false)
	end
end

local function stopMouseLook()
	if not mouseLookEnabled then
		return
	end
	mouseLookEnabled = false
	
	if oldCameraState ~= "freeLookCamera" then
		CameraManager.setState(oldCameraState, false, 5)
		GarageUI.setVisible(true)
	end
end

function CameraManager.start()
	CameraManager.setState("startingCamera", true)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientCursorMove", root, mouseMove)
	addEventHandler("onClientKey", root, handleKey)
	bindKey("mouse1", "down", startMouseLook)
	bindKey("mouse1", "up", stopMouseLook)

	exports.dpCameraViews:resetCameraView()
end

function CameraManager.stop()
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientCursorMove", root, mouseMove)
	removeEventHandler("onClientKey", root, handleKey)
	unbindKey("mouse1", "down", startMouseLook)
	unbindKey("mouse1", "up", stopMouseLook)
	Camera.setTarget(localPlayer)
end

addCommandHandler("cam", function (cmd, name)
	CameraManager.setState(name)
end)

function CameraManager.getTargetPosition()
	return camera.targetPosition
end

function CameraManager.getRotation()
	return camera.rotationHorizontal, camera.rotationVertical
end

function CameraManager.isMouseLookEnabled()
	return not not mouseLookEnabled
end