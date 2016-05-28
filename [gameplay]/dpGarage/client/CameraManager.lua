CameraManager = {}

local ANIMATION_SPEED = 2
local currentAnimationSpeed = ANIMATION_SPEED
local currentCameraState
local MOUSE_LOOK_SPEED = 50
local mouseLookEnabled = false
local MOUSE_LOOK_VERTICAL_MAX = 33
local MOUSE_LOOK_VERTICAL_MIN = -3

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
	Camera.setMatrix(
		camera.targetPosition + cameraOffset * camera.distance, 
		camera.targetPosition - shakeOffset * 4, 
		camera.roll, 
		camera.FOV
	)
end

function CameraManager.setState(name, noAnimation, animationSpeed)
	if not noAnimation and type(animationSpeed) == "number" then
		currentAnimationSpeed = animationSpeed
	else
		currentAnimationSpeed = ANIMATION_SPEED
	end
	for k, v in pairs(cameraPresets[name]) do
		if k == "targetPosition" then
			if type(v) == "string" then
				if v == "car" then				
					targetCamera.targetPosition = Vector3(GarageCar.getVehicle().position)
				else
					local vehicle = GarageCar.getVehicle()
					local componentOffset = Vector3(vehicle:getComponentPosition(v))
					targetCamera.targetPosition = vehicle.matrix:transformPosition(componentOffset)
				end
			else
				local vehicle = GarageCar.getVehicle()
				targetCamera.targetPosition = vehicle.matrix:transformPosition(v)
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

local function startMouseLook()
	if mouseLookEnabled then
		return
	end
	mouseLookEnabled = true
	oldCameraState = currentCameraState
	local rotationHorizontal = camera.rotationHorizontal
	local rotationVertical = camera.rotationVertical	
	CameraManager.setState("freeLookCamera", false, 5)
	camera.rotationHorizontal = rotationHorizontal
	camera.rotationVertical = rotationVertical
	targetCamera.rotationHorizontal = rotationHorizontal
	targetCamera.rotationVertical = rotationVertical		
	GarageUI.setVisible(false)
end

local function stopMouseLook()
	if not mouseLookEnabled then
		return
	end
	mouseLookEnabled = false
	CameraManager.setState(oldCameraState, false, 5)
	GarageUI.setVisible(true)
end

function CameraManager.start()
	CameraManager.setState("startingCamera", true)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientCursorMove", root, mouseMove)
	bindKey("mouse1", "down", startMouseLook)
	bindKey("mouse1", "up", stopMouseLook)
end

function CameraManager.stop()
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientCursorMove", root, mouseMove)
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

function CameraManager.isMouseLookEnabled()
	return not not mouseLookEnabled
end