UserVehicles = {}
local VEHICLES_TABLE_NAME = "vehicles"

function UserVehicles.setup()
	DatabaseTable.create(VEHICLES_TABLE_NAME, {
		{ name="owner_id", type=DatabaseTable.ID_COLUMN_TYPE, options="NOT NULL" },
		{ name="model", type="smallint", options="UNSIGNED NOT NULL" },
		-- Пробег
		{ name="mileage", type="bigint", options="UNSIGNED NOT NULL DEFAULT 0"},
		-- Тюнинг
		{ name="color", type="int", options="NOT NULL DEFAULT 16755200" },
		{ name="bodykit", type="int", options="NOT NULL DEFAULT 1" },
		{ name="spoiler", type="smallint", options="UNSIGNED NOT NULL DEFAULT 0" },
		{ name="wheels", type="smallint", options="UNSIGNED NOT NULL DEFAULT 0" },
		{ name="stickers", type="MEDIUMTEXT" }
	}, "FOREIGN KEY (owner_id)\n\tREFERENCES users("..DatabaseTable.ID_COLUMN_NAME..")\n\tON DELETE CASCADE", 
	function (result) 
		if not result then
			outputDebugString("Vehicles table already exists")
		end
	end)
end

-- Добавление автомобиля в аккаунт игрока
function UserVehicles.addVehicle(ownerId, model, callback)
	if 	type(ownerId) ~= "number" or type(model) ~= "number" then
		executeCallback(callback, false)
		return false
	end
	-- Проверка модели
	if not exports.dpUtils:isValidVehicleModel(model) then
		executeCallback(callback, false)
		return false
	end
	-- Обращение к бд
	local success = DatabaseTable.insert(VEHICLES_TABLE_NAME, { owner_id = ownerId, model = model}, callback)

	if not success then
		executeCallback(callback, false)
	end
	return success
end

-- Информация об автомобиле
function UserVehicles.getVehicle(vehicleId, callback)
	if type(vehicleId) ~= "number" then
		executeCallback(callback, false)
		return false
	end

	local success = DatabaseTable.select(VEHICLES_TABLE_NAME, {}, {_id = vehicleId}, 
	function (result)
		if result then
			if type(result) ~= "table" or #result == 0 then
				executeCallback(callback, false)
			else
				executeCallback(callback, result[1])
			end		
		else
			executeCallback(callback, false)
		end
	end)
	if not success then
		executeCallback(callback, false)
	end
	return success
end

-- Информация об автомобиле
function UserVehicles.updateVehicle(vehicleId, fields, callback)
	if type(vehicleId) ~= "number" or type(fields) ~= "table" then
		executeCallback(callback, false)
		return false
	end

	local success = DatabaseTable.update(VEHICLES_TABLE_NAME, fields, {_id = vehicleId}, 
	function (result)
		executeCallback(callback, not not result)
	end)
	if not success then
		executeCallback(callback, false)
	end
	return success
end

-- Список всех автомобилей игрока
function UserVehicles.getVehicles(ownerId, callback)
	if type(ownerId) ~= "number" then
		executeCallback(callback, false)
		return false
	end
	local success = DatabaseTable.select(VEHICLES_TABLE_NAME, {}, {owner_id = ownerId}, 
	function (result)
		if result then
			if type(result) ~= "table" or #result == 0 then
				executeCallback(callback, false)
			else
				executeCallback(callback, result)
			end		
		else
			executeCallback(callback, false)
		end
	end)
	if not success then
		executeCallback(callback, false)
	end
	return success
end

-- Список id автомобилей игрока
function UserVehicles.getVehiclesIds(ownerId, callback)
	if type(ownerId) ~= "number" then
		executeCallback(callback, false)
		return false
	end
	local success = DatabaseTable.select(VEHICLES_TABLE_NAME, {"_id"}, {owner_id = ownerId}, 
	function (result)
		if result then
			if type(result) ~= "table" or #result == 0 then
				executeCallback(callback, false)
			else
				executeCallback(callback, result)
			end		
		else
			executeCallback(callback, false)
		end
	end)
	if not success then
		executeCallback(callback, false)
	end
	return success
end

function UserVehicles.changeOwner(vehicleId, newOwnerId, callback)
	return UserVehicles.updateVehicle(vehicleId, {owner_id = newOwnerId}, callback)
end

-- Удаление автомобия из аккаунта
function UserVehicles.removeVehicle(vehicleId)

end