-- Выбор автомобиля

GarageCar = {}
local CAR_POSITION = Vector3 { x = 2915.438, y = -3186.282, z = 2535.244 }
local vehicle
local vehiclesList = {}
local currentVehicle = 1

-- Время, на которое размораживается машина при смене модели
local VEHICLE_UNFREEZE_TIME = 500
local unfreezeTimer

local function updateVehicle()
	if not vehiclesList[currentVehicle] then
		outputDebugString("Could not load vehicle: " .. tostring(currentVehicle))
		return
	end

	vehicle.model = vehiclesList[currentVehicle].model
	vehicle:setColor(212, 0, 40, 255, 255, 255)
	-- Разморозка машины на 1 сек
	vehicle.frozen = false
	if isTimer(unfreezeTimer) then killTimer(unfreezeTimer) end
	unfreezeTimer = setTimer(function ()
		vehicle.frozen = true
	end, VEHICLE_UNFREEZE_TIME, 1)
end

function GarageCar.getId()
	return vehiclesList[currentVehicle]._id
end

function GarageCar.start(vehicles)
	vehiclesList = vehicles
	currentVehicle = 1
	vehicle = createVehicle(411, CAR_POSITION)
	unfreezeTimer = setTimer(function ()
		vehicle.frozen = true
	end, VEHICLE_UNFREEZE_TIME, 1)
	vehicle.rotation = Vector3(0, 0, -90)

	updateVehicle()
end

function GarageCar.stop()
	if isElement(vehicle) then
		destroyElement(vehicle)
	end
end

function GarageCar.getVehicle()
	return vehicle
end

function GarageCar.showNextCar()
	currentVehicle = currentVehicle + 1
	if currentVehicle > #vehiclesList then
		currentVehicle = 1
	end
	updateVehicle()
end

function GarageCar.showPreviousCar()
	currentVehicle = currentVehicle - 1
	if currentVehicle < 1 then
		currentVehicle = #vehiclesList
	end
	updateVehicle()
end