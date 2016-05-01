CameraManager = {}
local ANIMATION_SPEED = 2
local camera = {
	rotationHorizontal = 0,
	rotationVertical = 0,
	distance = 5,
	FOV = 70,
	targetPosition = Vector3(),
	roll = 0
}
local targetCamera = {}

local cameraPresets = {}
cameraPresets.vehicleSelect = {
	targetPosition = Vector3(1.4, 1, 0),
	rotationHorizontal = 30,
	rotationVertical = 5,
	distance = 7,
	FOV = 50,
	roll = 0
}
cameraPresets.startingCamera = {
	targetPosition = Vector3(1.4, 1, 0),
	rotationHorizontal = 30,
	rotationVertical = 5,
	distance = 14,
	FOV = 20,
	roll = 0
}
cameraPresets.wheelRF = {
	targetPosition = "wheel_rf_dummy",
	rotationHorizontal = -70,
	rotationVertical = 10,
	distance = 3.5,
	FOV = 30,
	roll = 0
}

cameraPresets.wheelLF = {
	targetPosition = "wheel_lf_dummy",
	rotationHorizontal = -70 + 180,
	rotationVertical = 10,
	distance = 3.5,
	FOV = 30,
	roll = 0
}

cameraPresets.frontBump = {
	targetPosition = Vector3(1.4, 1, 0),
	rotationHorizontal = 30,
	rotationVertical = 5,
	distance = 7,
	FOV = 50,
	roll = 0
}

cameraPresets.rearBump = {
	targetPosition = Vector3(-1, -1, 0),
	rotationHorizontal = 190,
	rotationVertical = 5,
	distance = 7,
	FOV = 45,
	roll = 0
}

local function update(deltaTime)
	deltaTime = deltaTime / 1000

	for k, v in pairs(targetCamera) do
		camera[k] = camera[k] + (targetCamera[k] - camera[k]) * deltaTime * ANIMATION_SPEED
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

function CameraManager.setState(name, noAnimation)
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
	CameraManager.setState("vehicleSelect", false)
	addEventHandler("onClientPreRender", root, update)
end

function CameraManager.stop()
	removeEventHandler("onClientPreRender", root, update)
	Camera.setTarget(localPlayer)
end

addCommandHandler("cam", function (cmd, name)
	CameraManager.setState(name)
end)