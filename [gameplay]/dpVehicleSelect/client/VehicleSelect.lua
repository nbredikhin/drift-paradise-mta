VehicleSelect = {}
local isActive = false
local positions = {
	Vector3 { x = -1945.861, y = 257.595, z = 40.774 },
	Vector3 { x = -1950.861, y = 257.595, z = 40.774 },
	Vector3 { x = -1955.859, y = 257.595, z = 40.774 }
}
local CAMERA_POSITION = Vector3 { x = -1950.861, y = 266.595, z = 42.774 }

local targetLookPosition = positions[1]
local currentLookPosition = targetLookPosition

local currentVehicle = 1

local vehicles = {}
local isSelected = false

local function update(dt)
	local shakeX = math.sin(getTickCount() / 740) * (math.sin(getTickCount() / 300) + 1) * 0.01
	local shakeZ = math.sin(getTickCount() / 430) * (math.cos(getTickCount() / 600) + 1) * 0.01
	local offset = Vector3(shakeX, 0, shakeZ)
	local deltaTime = dt / 1000
	currentLookPosition = currentLookPosition + (targetLookPosition - currentLookPosition) * 2 * deltaTime
	currentLookPosition = currentLookPosition + offset / 5
	Camera.setMatrix(CAMERA_POSITION - offset / 2, currentLookPosition + Vector3(0, 0, 0.3), 0, 45)
end

local function onKey(key, state)
	if not state then
		return
	end
	if isSelected then
		return
	end
	if key == "enter" then
		isSelected = true
		setTimer(function()
			triggerServerEvent("dpVehicleSelect.selected", resourceRoot, currentVehicle)
			VehicleSelect.exit()
		end, 1500, 1)
		fadeCamera(false, 1)
		return
	end
	if key == "arrow_r" then
		currentVehicle = currentVehicle + 1
	elseif key == "arrow_l" then
		currentVehicle = currentVehicle - 1
	end
	currentVehicle = math.min(#positions, currentVehicle)
	currentVehicle = math.max(1, currentVehicle)

	targetLookPosition = positions[currentVehicle]
end

function VehicleSelect.enter(models)
	if not models then
		return 
	end
	if isActive then
		return
	end
	for i, pos in ipairs(positions) do
		vehicles[i] = Vehicle(models[i], pos)
		vehicles[i].rotation = Vector3(0, 0, 30 * (i - 2))
	end
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientKey", root, onKey)
	exports.dpHUD:setVisible(false)
	isActive = true
	isSelected = false
	fadeCamera(true, 1)
end

function VehicleSelect.exit()
	if not isActive then
		return
	end
	isActive = false
	exports.dpHUD:setVisible(true)
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientKey", root, onKey)
	fadeCamera(false, 1)
end

addEvent("dpVehicleSelect.start", true)
addEventHandler("dpVehicleSelect.start", root, function(models)
	if not models then
		models = {411, 411, 411}
	end
	VehicleSelect.enter(models)
end)