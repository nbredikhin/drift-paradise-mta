CameraManager = {}

local ANIMATION_SPEED = 2
local currentAnimationSpeed = ANIMATION_SPEED
local MOUSE_LOOK_OFFSET = 0.1

local camera = {
	rotationHorizontal = 0,
	rotationVertical = 0,
	distance = 5,
	FOV = 70,
	targetPosition = Vector3(),
	roll = 0
}
local targetCamera = {}

local function update(deltaTime)
	deltaTime = deltaTime / 1000

	for k, v in pairs(targetCamera) do
		camera[k] = camera[k] + (targetCamera[k] - camera[k]) * deltaTime * currentAnimationSpeed
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