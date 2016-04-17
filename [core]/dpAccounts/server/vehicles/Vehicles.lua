Vehicles = {}
local VEHICLES_TABLE_NAME = "vehicles"

function Vehicles.setup()
	DatabaseTable.create(VEHICLES_TABLE_NAME, {
		{ name="owner_id", type=DatabaseTable.ID_COLUMN_TYPE, options="NOT NULL" },
		{ name="model", type="smallint", options="UNSIGNED NOT NULL" },
		-- Пробег
		{ name="mileage", type="bigint", options="UNSIGNED NOT NULL DEFAULT 0"},
		-- Тюнинг
		{ name="color", type="int", options="NOT NULL DEFAULT 16755200" },
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
function Vehicles.addPlayerVehicle(player, model)
	if 	not exports.dpUtils:argcheck(player, "player") or 
		not exports.dpUtils:argcheck(model, "number")
	then
		triggerEvent("dpAccounts.addVehicleResponse", player, false)
		return false
	end
	-- Id аккаунта игрока
	local ownerId = tonumber(player:getData("_id"))
	if not ownerId then
		triggerEvent("dpAccounts.addVehicleResponse", player, false, "not_authorized")
		return false
	end
	-- Проверка модели
	if not exports.dpUtils:isValidVehicleModel(model) then
		triggerEvent("dpAccounts.addVehicleResponse", player, false, "invalid_model")
		return false
	end
	-- Обращение к бд
	local success = DatabaseTable.insert(VEHICLES_TABLE_NAME, {
		owner_id = ownerId,
		model = model
	}, function (result)
		if result then
			triggerEvent("dpAccounts.addVehicleResponse", player, true)
		else
			triggerEvent("dpAccounts.addVehicleResponse", player, false, "db_error")
		end
	end)

	if not success then
		triggerEvent("dpAccounts.addVehicleResponse", player, false, "db_error")
	end
	return success
end

-- Информация об автомобиле
function Vehicles.getVehicleData(vehicleId)
	if not exports.dpUtils:argcheck(vehicleId, "number") then
		triggerEvent("dpAccounts.getVehicleDataResponse", player, false)
		return false
	end

	local success = DatabaseTable.select(VEHICLES_TABLE_NAME, {}, {_id = vehicleId}, 
	function (result)
		if result then
			if type(result) ~= "table" or #result == 0 then
				triggerEvent("dpAccounts.getVehicleDataResponse", player, false, "no_vehicle")
			else
				triggerEvent("dpAccounts.getVehicleDataResponse", player, result[1])
			end		
		else
			triggerEvent("dpAccounts.getVehicleDataResponse", player, false, "no_vehicle")
		end
	end)
	if not success then
		triggerEvent("dpAccounts.getVehicleDataResponse", player, false, "db_error")
	end
	return success
end

-- Информация об автомобиле
function Vehicles.setVehicleData(vehicleId, fields)
	if 	not exports.dpUtils:argcheck(vehicleId, "number") or 
		not exports.dpUtils:argcheck(fields, "table") then
		triggerEvent("dpAccounts.setVehicleDataResponse", player, false)
		return false
	end

	local success = DatabaseTable.update(VEHICLES_TABLE_NAME, fields, {_id = vehicleId}, 
	function (result)
		if result then
			triggerEvent("dpAccounts.setVehicleDataResponse", player, true)
		else
			triggerEvent("dpAccounts.setVehicleDataResponse", player, false, "no_vehicle")
		end
	end)
	if not success then
		triggerEvent("dpAccounts.setVehicleDataResponse", player, false, "db_error")
	end
	return success
end

-- Список автомобилей игрока
function Vehicles.getPlayerVehicles(player)
	if not exports.dpUtils:argcheck(player, "player") then
		triggerEvent("dpAccounts.getPlayerVehiclesResponse", player, false)
		return false
	end
	-- Id аккаунта игрока
	local ownerId = tonumber(player:getData("_id"))
	if not ownerId then
		triggerEvent("dpAccounts.getPlayerVehiclesResponse", player, false, "not_authorized")
		return false
	end	

	local success = DatabaseTable.select(VEHICLES_TABLE_NAME, {}, {owner_id = ownerId}, 
	function (result)
		if result then
			if type(result) ~= "table" or #result == 0 then
				triggerEvent("dpAccounts.getPlayerVehiclesResponse", player, false, "no_vehicles")
			else
				triggerEvent("dpAccounts.getPlayerVehiclesResponse", player, result)
			end		
		else
			triggerEvent("dpAccounts.getPlayerVehiclesResponse", player, false, "no_vehicles")
		end
	end)
	if not success then
		triggerEvent("dpAccounts.getPlayerVehiclesResponse", player, false, "db_error")
	end
	return success
end

-- Удаление автомобия из аккаунта
function Vehicles.removeVehicle(vehicleId)

end