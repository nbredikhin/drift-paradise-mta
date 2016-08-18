CameraManager = {}

local ANIMATION_SPEED = 5
local currentAnimationSpeed = ANIMATION_SPEED
local MOUSE_LOOK_OFFSET = 0.1

local camera = {
	rotationHorizontal = 0,
	rotationVertical = 0,
	distance = 5,
	FOV = 70,
	targetPosition = Vector3(0, 0, 0),
	roll = 0
}

local targetCamera = {}

local MAX_FOV = 50

local cameraPresets = {}
cameraPresets.startingCamera = {
	targetPosition = Vector3(-1, 0, 1),
	rotationHorizontal = 240,
	rotationVertical = 4,
	distance = 16,
	FOV = MAX_FOV,
	roll = 0
}

local function wrapAngle(value)
	if not value then
		return 0
	end
	value = math.mod(value, 360)
	if value < 0 then
		value = value + 360
	end
	return value
end

local function differenceBetweenAngles(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	while difference < -180 do
		difference = difference + 360
	end
	while difference > 180 do
		difference = difference - 360
	end
	return difference
end

local function update(deltaTime)
	deltaTime = deltaTime / 1000

	for k, v in pairs(targetCamera) do
		if k == "rotationHorizontal" then
			local diff = differenceBetweenAngles(camera[k], targetCamera[k])
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

function CameraManager.getTargetCamera()
	return targetCamera
end

function CameraManager.setState(name, noAnimation, animationSpeed)
	if not noAnimation and type(animationSpeed) == "number" then
		currentAnimationSpeed = animationSpeed
	else
		currentAnimationSpeed = ANIMATION_SPEED
	end
	local vehicle = Carshop.getVehicle()
	for k, v in pairs(cameraPresets[name]) do
		if k == "targetPosition" then
			if type(v) == "string" then
				if v == "car" then				
					targetCamera.targetPosition = Vector3(vehicle.position)
				else
					local componentOffset = Vector3(vehicle:getComponentPosition(v))
					targetCamera.targetPosition = vehicle.matrix:transformPosition(componentOffset)
				end
			else
				targetCamera.targetPosition = vehicle.matrix:transformPosition(v)
			end
			if noAnimation then
				camera.targetPosition = Vector3(targetCamera.targetPosition)
			end
		else
			if k == "rotationHorizontal" then
				v = wrapAngle(v)
			end
			targetCamera[k] = v
			if noAnimation then
				camera[k] = v
			end
		end
	end
end

function CameraManager.start()
	CameraManager.setState("startingCamera", true)
	addEventHandler("onClientPreRender", root, update)
end

function CameraManager.stop()
	removeEventHandler("onClientPreRender", root, update)
	Camera.setTarget(localPlayer)
end

addCommandHandler("cam", function (cmd, name)
	CameraManager.setState(name)
end)

function CameraManager.getTargetPosition()
	return camera.targetPosition
end