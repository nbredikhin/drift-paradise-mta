VehicleSpawn = {}
-- Время, через которое удаляется взорвавшийся автомобиль
local EXPLODED_VEHICLE_DESTROY_TIMEOUT = 5000
-- Автомобили, заспавненные игроком
-- ключ - владелец
local userSpawnedVehicles = {}
-- data, находящаяся в автомобиле
local dataFields = {
	"_id", "owner_id", "mileage", "tuning", "stickers"
}
local autosaveFields = {
	"mileage"
}
-- Поля, которые можно менять на клиенте
local allowedFields = {
	mileage = true
}

function VehicleSpawn.getPlayerSpawnedVehicles(player)
	if not isElement(player) then
		return false
	end
	local playerId = player:getData("_id")
	if not userSpawnedVehicles[playerId] then
		return {}
	end
	local spawnedVehicles = {}
	for vehicle in pairs(userSpawnedVehicles[playerId]) do
		table.insert(spawnedVehicles, vehicle)
	end
	return spawnedVehicles
end

function VehicleSpawn.getSpawnedVehicle(vehicleId)
	return getElementByID(tostring(vehicleId))
end

function VehicleSpawn.getVehicleOwnerPlayer(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local ownerId = vehicle:getData("owner_id")
	return Users.getPlayerById(ownerId)
end

function VehicleSpawn.isPlayerOwningVehicle(player, vehicle)
	if not isElement(player) or not isElement(vehicle) then
		return false
	end
	local playerId = player:getData("_id")
	local ownerId = vehicle:getData("owner_id")
	return playerId == ownerId
end

function VehicleSpawn.autosaveVehicle(vehicle, saveTuning, saveStickers)
	if not isElement(vehicle) then
		return false
	end
	local vehicleId = vehicle:getData("_id")
	if not vehicleId then
		return false
	end

	-- Сохранение тюнинга и наклеек
	local tuningTable
	if saveTuning then
		tuningTable = {}
		for k in pairs(VehicleTuning.defaultTuningTable) do
			tuningTable[k] = vehicle:getData(k)
			if not tuningTable[k] then 
				tuningTable[k] = nil
			end 
		end
	end
	local stickersTable
	if saveStickers then
		stickersTable = vehicle:getData("stickers")
		if not stickersTable then
			stickersTable = {}
		end
	end
	if saveTuning or saveStickers then
		VehicleTuning.updateVehicleTuning(vehicleId, tuningTable, stickersTable)
	end

	-- Сохранение даты
	local fields = {}
	for i, name in ipairs(autosaveFields) do
		fields[name] = vehicle:getData(name)
	end
	UserVehicles.updateVehicle(vehicleId, fields)
	return true
end

function VehicleSpawn.returnToGarage(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local playerId = vehicle:getData("owner_id")
	if not playerId then
		return false
	end
	if type(userSpawnedVehicles[playerId]) ~= "table" then
		return false
	end
	userSpawnedVehicles[playerId][vehicle] = nil
	VehicleSpawn.autosaveVehicle(vehicle)
	destroyElement(vehicle)
end

function VehicleSpawn.spawn(vehicleId, position, rotation)
	if type(vehicleId) ~= "number" or type(position) ~= "userdata" then
		executeCallback(callback, false)
		return false
	end
	if not rotation then rotation = Vector3() end

	local vehicleInfo = UserVehicles.getVehicle(vehicleId)
	if type(vehicleInfo) ~= "table" or #vehicleInfo == 0 then
		return false
	end
	vehicleInfo = vehicleInfo[1]
	if not vehicleInfo.owner_id then
		return false
	end	
	local previouslySpawendVehicle = VehicleSpawn.getSpawnedVehicle(vehicleInfo._id)
	if isElement(previouslySpawendVehicle) then
		VehicleSpawn.returnToGarage(previouslySpawendVehicle)
	end

	local user = Users.get(vehicleInfo.owner_id, { "username" })
	if type(user) ~= "table" or #user == 0 then
		return false
	end
	user = user[1]

	local vehicle = Vehicle(vehicleInfo.model, position, rotation)
	vehicle:setColor(255, 0, 0)

	for i, name in ipairs(dataFields) do
		vehicle:setData(name, vehicleInfo[name])
	end
	vehicle:setData("owner_username", user.username)
	vehicle.id = tostring(vehicleInfo._id)

	if not userSpawnedVehicles[vehicleInfo.owner_id] then
		userSpawnedVehicles[vehicleInfo.owner_id] = {}
	end
	userSpawnedVehicles[vehicleInfo.owner_id][vehicle] = true
	VehicleTuning.applyToVehicle(vehicle, vehicleInfo.tuning, vehicleInfo.stickers)
	return vehicle
end

-- Защита даты 
addEventHandler("onElementDataChange", root, function(dataName, oldValue)
	if not client then
		return
	end
	if source.type == "vehicle" then
		if not allowedFields[dataName] then
			source:setData(dataName, oldValue)
		end
	end
end)

addEventHandler("onVehicleExplode", root, function()
	local vehicle = source
	setTimer(function ()
		if isElement(vehicle) then
			VehicleSpawn.returnToGarage(vehicle)
		end
	end, EXPLODED_VEHICLE_DESTROY_TIMEOUT, 1)
end)

addEventHandler("onPlayerQuit", root, function ()
	local vehicles = VehicleSpawn.getPlayerSpawnedVehicles(source)
	for i, vehicle in ipairs(vehicles) do
		VehicleSpawn.returnToGarage(vehicle)
	end
end)