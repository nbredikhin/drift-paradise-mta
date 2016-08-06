VehicleSpawn = {}
-- Время, через которое удаляется взорвавшийся автомобиль
local EXPLODED_VEHICLE_DESTROY_TIMEOUT = 5000
-- Автомобили, заспавненные игроком
-- ключ - userId владельца (string)
local userSpawnedVehicles = {}
-- data, находящаяся в автомобиле
local dataFields = {
	"_id", "owner_id", "mileage", "tuning", "stickers"
}
local autosaveFields = {
	"mileage",
}
-- Поля, которые можно менять на клиенте
local allowedFields = {
	mileage = true,
}

local function getUserSpawnedVehiclesTable(userId)
	if type(userId) ~= "number" then
		if type(userId) == "string" then
			userId = tonumber(userId)
		else
			return
		end
	end

	return userSpawnedVehicles[userId]
end

local function addUserSpawnedVehicle(userId, vehicle)
	if type(userId) ~= "number" then
		if type(userId) == "string" then
			userId = tonumber(userId)
		else
			return
		end
	end

	if not userSpawnedVehicles[userId] then
		userSpawnedVehicles[userId] = {}
	end
	userSpawnedVehicles[userId][vehicle] = true
end

local function removeUserSpawnedVehicle(userId, vehicle)
	if type(userId) ~= "number" then
		if type(userId) == "string" then
			userId = tonumber(userId)
		else
			return
		end
	end

	if not userSpawnedVehicles[userId] then
		userSpawnedVehicles[userId] = {}
	end
	userSpawnedVehicles[userId][vehicle] = nil
end

-- Возвращает массив автомобилей, принадлежащих пользователю с userId
function VehicleSpawn.getUserSpawnedVehicles(userId)
	if not userId then
		return false
	end
	if not getUserSpawnedVehiclesTable(userId) then
		return {}
	end
	local spawnedVehicles = {}
	for vehicle in pairs(getUserSpawnedVehiclesTable(userId)) do
		table.insert(spawnedVehicles, vehicle)
	end
	return spawnedVehicles
end

-- Возвращает массив автомобилей, заспавненных игроком
function VehicleSpawn.getPlayerSpawnedVehicles(player)
	if not isElement(player) then
		return false
	end
	local userId = player:getData("_id")
	return VehicleSpawn.getUserSpawnedVehicles(userId)
end

-- Возвращает элемент заспавненного автомобиля по его _id в базе данных
function VehicleSpawn.getSpawnedVehicle(vehicleId)
	return getElementByID("vehicle_" .. tostring(vehicleId))
end

-- Возвращает игрока, который является владельцем автомобиля
function VehicleSpawn.getVehicleOwnerPlayer(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local ownerId = vehicle:getData("owner_id")
	return Users.getPlayerById(ownerId)
end

-- Возвращает, является ли игрок владельцем автомобиля
function VehicleSpawn.isPlayerOwningVehicle(player, vehicle)
	if not isElement(player) or not isElement(vehicle) then
		return false
	end
	local playerId = player:getData("_id")
	local ownerId = vehicle:getData("owner_id")
	return playerId == ownerId
end

-- Автосохранение
local function autosaveVehicle(vehicle, saveTuning, saveStickers)
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

-- Удаляет заспавненный автомобиль
function VehicleSpawn.returnToGarage(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local playerId = vehicle:getData("owner_id")
	if not playerId then
		return false
	end
	if type(getUserSpawnedVehiclesTable(playerId)) ~= "table" then
		return false
	end
	removeUserSpawnedVehicle(playerId, vehicle)
	autosaveVehicle(vehicle)
	destroyElement(vehicle)
	return true
end

-- Возвращает все автомобили, принадленащие пользователю userId в гараж
function VehicleSpawn.returnUserVehiclesToGarage(userId)
	local vehicles = VehicleSpawn.getUserSpawnedVehicles(userId)
	if type(vehicles) ~= "table" then
		return false
	end
	for i, vehicle in ipairs(vehicles) do
		VehicleSpawn.returnToGarage(vehicle)
	end
	return true
end

-- Спавн автомобиля из гаража по _id
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

	local user = Users.get(vehicleInfo.owner_id, { "username" })
	if type(user) ~= "table" or #user == 0 then
		return false
	end
	user = user[1]

	-- Вернуть все автомобили игрока в гараж
	VehicleSpawn.returnUserVehiclesToGarage(vehicleInfo.owner_id)

	-- Создание автомобиля
	local vehicle = Vehicle(vehicleInfo.model, position, rotation)
	vehicle:setColor(255, 0, 0)

	for i, name in ipairs(dataFields) do
		vehicle:setData(name, vehicleInfo[name])
	end
	vehicle:setData("owner_username", user.username)
	vehicle.id = "vehicle_" .. tostring(vehicleInfo._id)

	addUserSpawnedVehicle(vehicleInfo.owner_id, vehicle)
	VehicleTuning.applyToVehicle(vehicle, vehicleInfo.tuning, vehicleInfo.stickers)

	-- Выключить фары
	vehicle:setData("LightsState", false)
	triggerClientEvent(root, "onClientVehicleCreated", vehicle)
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
	if type(vehicles) == "table" then
		for i, vehicle in ipairs(vehicles) do
			VehicleSpawn.returnToGarage(vehicle)
		end
	end
end)