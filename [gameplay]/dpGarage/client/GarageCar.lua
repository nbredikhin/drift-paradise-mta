-- Выбор автомобиля
GarageCar = {}

addEvent("dpGarage.loaded", false)

local CAR_POSITION = Vector3 { x = 2915.438, y = -3186.282, z = 2535.244 }
local vehicle
local vehiclesList = {}
local currentVehicle = 1
local currentTuningTable = {}

-- Время, на которое размораживается машина при смене модели
local VEHICLE_UNFREEZE_TIME = 500
local unfreezeTimer

local configurationData = {"WheelsOffsetF", "WheelsOffsetR", "WheelsWidthF", "WheelsWidthR", "WheelsAngleF", "WheelsAngleR", "WheelsSize"}
local colorsData = {"BodyColor", "WheelsColorR", "WheelsColorF", "SpoilerColor"}

local function updateVehicle()
	if not vehiclesList[currentVehicle] then
		outputDebugString("Could not load vehicle: " .. tostring(currentVehicle))
		return
	end

	vehicle.model = vehiclesList[currentVehicle].model

	vehicle:setColor(255, 0, 0, 255, 255, 255)
	-- Разморозка машины на 1 сек
	vehicle.frozen = false
	vehicle.velocity = Vector3(0, 0, -0.01)
	vehicle.velocity = Vector3(0, 0, 0.02)
	vehicle.position = CAR_POSITION
	if isTimer(unfreezeTimer) then killTimer(unfreezeTimer) end
	unfreezeTimer = setTimer(function ()
		vehicle.frozen = true
	end, VEHICLE_UNFREEZE_TIME, 1)


	currentTuningTable = {}
	if type(vehiclesList[currentVehicle].tuning) == "string" then
		currentTuningTable = fromJSON(vehiclesList[currentVehicle].tuning)
	end


	-- Наклейки
	local stickersJSON = vehiclesList[currentVehicle].stickers
	if stickersJSON then
		local stickers = fromJSON(stickersJSON)
		if type(stickers) ~= "table" then
			stickers = {}
		end
		vehicle:setData("stickers", stickers)	
	else
		vehicle:setData("stickers", {})
	end
	GarageCar.resetTuning()
	CarTexture.reset()
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

	addEventHandler("dpGarage.loaded", resourceRoot, updateVehicle)
end

function GarageCar.stop()
	if isElement(vehicle) then
		destroyElement(vehicle)
	end
	removeEventHandler("dpGarage.loaded", resourceRoot, updateVehicle)
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

function GarageCar.showCarById(id)
	for i, vehicle in ipairs(vehiclesList) do
		if vehicle._id == id then
			currentVehicle = i
			updateVehicle()
			return true
		end
	end
	return false
end

function GarageCar.previewTuning(name, value)
	vehicle:setData(name, value)
end

function GarageCar.applyTuning(name, value)
	vehicle:setData(name, value)
	currentTuningTable[name] = value
end

function GarageCar.applyTuningFromData(name)
	currentTuningTable[name] = vehicle:getData(name)
end

function GarageCar.resetTuning()
	-- Сброс компонентов
	local componentNames = exports.dpVehicles:getComponentsNames()

	for i, name in ipairs(componentNames) do
		vehicle:setData(name, currentTuningTable[name])
	end

	for i, name in ipairs(configurationData) do
		local value = currentTuningTable[name]
		if type(value) == "number" then
			vehicle:setData(name, value)
		else
			vehicle:setData(name, 0)
		end
	end

	-- Цвета
	for i, name in ipairs(colorsData) do
		if currentTuningTable[name] then
			vehicle:setData(name, currentTuningTable[name])
		else
			vehicle:setData(name, {255, 255, 255})
		end
	end
end

function GarageCar.getTuningTable()
	local componentNames = exports.dpVehicles:getComponentsNames()
	local tuningTable = {}
	for i, name in ipairs(componentNames) do
		tuningTable[name] = vehicle:getData(name, id)
	end

	for i, name in ipairs(configurationData) do
		tuningTable[name] = vehicle:getData(name)
		if type(tuningTable[name]) == "number" then
			tuningTable[name] = math.floor(tuningTable[name] * 100) / 100
		end
	end	

	-- Цвета
	tuningTable.BodyColor = vehicle:getData("BodyColor")
	tuningTable.WheelsColorR = vehicle:getData("WheelsColorR")
	tuningTable.WheelsColorF = vehicle:getData("WheelsColorF")

	-- TODO:
	-- BodyTexture 	= false
	-- NeonColor 		= false
	-- Numberplate 	= "DRIFT"
	-- Nitro 			= 0
	-- Windows			= 0
	return tuningTable
end

function GarageCar.save()
	CarTexture.save()
	local tuningTable = GarageCar.getTuningTable()
	vehiclesList[currentVehicle].tuning = toJSON(tuningTable)
	vehiclesList[currentVehicle].stickers = toJSON(vehicle:getData("stickers"))
	triggerServerEvent("dpGarage.saveCar", resourceRoot,
		currentVehicle, 
		tuningTable,
		vehicle:getData("stickers")
	)
end