local DATA_NAME = "Exhaust"
local MODELS = {1853, 1854, 1855, 1856, 1857, 1858, 1859, 1860, 1861, 1862}

local vehicleExhausts = {}

local function removeVehicleExhausts(vehicle)
	if vehicleExhausts[vehicle] then
		for i, object in ipairs(vehicleExhausts[vehicle]) do
			if isElement(object) then
				destroyElement(object)
			end
		end
		vehicleExhausts[vehicle] = nil
	end
	vehicle:setComponentVisible("Exhaust0", false)	
	return true
end

local function updateVehicleExhaust(vehicle)
	local exhaust = vehicle:getData("Exhaust")
	if type(exhaust) ~= "number" then
		exhaust = 0
	end
	exhaust = exhaust + 1
	if not MODELS[exhaust] then
		return removeVehicleExhausts(vehicle)
	end
	removeVehicleExhausts(vehicle)
	vehicle:setComponentVisible("Exhaust0", false)

	local bumper = vehicle:getData("RearBump")
	if not bumper then
		bumper = 0
	end
	local exhaustTable = {}
	local x, y, z = vehicle:getComponentPosition("RearBumpExhaust" .. tostring(bumper))
	if not x then
		return removeVehicleExhausts(vehicle)
	end
	exhaustTable[1] = createObject(MODELS[exhaust], vehicle.position)
	exhaustTable[1]:attach(vehicle, x, y, z)

	-- Второй глушитель
	x, y, z = vehicle:getComponentPosition("SecondExhaust" .. tostring(bumper))
	if x then
		exhaustTable[2] = createObject(MODELS[exhaust], vehicle.position)
		exhaustTable[2]:attach(vehicle, x, y, z, 180, 0, 0)
		exhaustTable[2]:setScale(-1, -1, -1)
		exhaustTable[2].doubleSided = true
	end
	vehicleExhausts[vehicle] = exhaustTable
end

-- Обновить тюнинг всех автомобилей при запуске
addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		updateVehicleExhaust(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "vehicle" then
		updateVehicleExhaust(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	removeVehicleExhausts(source)
end)

addEventHandler("onClientElementDestroy", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	removeVehicleExhausts(source)
end)

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	updateVehicleExhaust(source)
end)