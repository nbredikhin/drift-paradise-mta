Houses = {}
local HOUSES_TABLE_NAME = "houses"

function Houses.setup()
	DatabaseTable.create(HOUSES_TABLE_NAME, {
		{ name="owner_id", type=DatabaseTable.ID_COLUMN_TYPE, options="UNIQUE" },
		{ name="data", type="MEDIUMTEXT" },
		{ name="price", type="bigint", options="UNSIGNED NOT NULL DEFAULT 0"},
	}, "FOREIGN KEY (owner_id)\n\tREFERENCES users(" .. DatabaseTable.ID_COLUMN_NAME .. ")\n\tON DELETE CASCADE")
	
	local counter = 0
	local updatedCounter = 0
	for id, house in ipairs(housesList) do
		local row = DatabaseTable.select(HOUSES_TABLE_NAME, {"_id", "price"}, {_id = id})
		if not row or #row == 0 then
			local status = DatabaseTable.insert(HOUSES_TABLE_NAME, {
				_id = id, 
				price = house.price, 
				data = toJSON(house.data)
			})
			if status then
				counter = counter + 1
			end
		else
			if row[1].price ~= house.price then
				if DatabaseTable.update(HOUSES_TABLE_NAME, {
						price = house.price, 
						data = toJSON(house.data)
					}, {_id = id}) 
				then
					updatedCounter = updatedCounter + 1
				end
			end
		end
	end
	if counter > 0 then
		outputDebugString("Added new houses: " .. tostring(counter))
	end
	if updatedCounter > 0 then
		outputDebugString("Updated houses: " .. tostring(updatedCounter))
	end

	-- Создать маркеры домов
	DatabaseTable.select(HOUSES_TABLE_NAME, {}, {}, function (result)
		if not result then
			return
		end
		for i, house in ipairs(result) do
			local data = fromJSON(house.data)
			local marker = exports.dpMarkers:createMarker("house", Vector3(unpack(data.enter)) - Vector3(0, 0, 0.5))
			local dimension = exports.dpHouses:getHouseDimension(i)
			marker:setData("_id", house._id)
			marker:setData("owner_id", house.owner_id)
			marker:setData("house_data", data)
			marker:setData("house_price", house.price)
			marker:setData("house_dimension", dimension)
			marker.id = "house_enter_marker_" .. tostring(house._id)
			marker:setData("dpMarkers.text", "")

			local exitMarker = exports.dpMarkers:createMarker("exit", Vector3(unpack(data.exit)) - Vector3(0, 0, 0.5))
			exitMarker.interior = data.interior
			exitMarker.dimension = dimension
			exitMarker:setData("house_exit_position", data.enter)
			exitMarker:setData("house_exit_rotation", data.enter_rotation)
			exitMarker.id = "house_exit_marker_" .. tostring(house._id)

			--local garageMarker = exports.dpMarkers:createMarker("garage", Vector3(unpack(data.garage)))
		end
	end)
end

function Houses.buyPlayerHouse(player, houseId)
	if not isElement(player) then
		return false
	end
	local playerId = player:getData("_id")
	if not playerId then
		outputDebugString("Houses.buyPlayerHouse: not authorized")
		triggerClientEvent("dpCore.buy_house", resourceRoot, false)
		return false
	end
	if not houseId then
		triggerClientEvent("dpCore.buy_house", resourceRoot, false)
		return
	end
	if player:getData("house_id") then
		-- Уже есть дом
		triggerClientEvent("dpCore.buy_house", resourceRoot, false)
		return false
	end
	return DatabaseTable.select(HOUSES_TABLE_NAME, {}, {_id = houseId}, function (house)
		if type(house) ~= "table" then
			-- Дом не найден
			triggerClientEvent("dpCore.buy_house", resourceRoot, false)
			return
		end
		if not house[1] then
			-- Дом не найден
			triggerClientEvent("dpCore.buy_house", resourceRoot, false)
			return
		end
		house = house[1]

		if house.owner_id then
			-- Уже есть владелец
			triggerClientEvent("dpCore.buy_house", resourceRoot, false)
			return
		end
		local playerMoney = player:getData("money")
		if not playerMoney then playerMoney = 0 end
		if player:getData("money") < house.price then
			-- Недостаточно денег
			triggerClientEvent("dpCore.buy_house", resourceRoot, false)
			--outputDebugString("Fail: not enough money")
			return 
		end
		DatabaseTable.update(HOUSES_TABLE_NAME, {owner_id = playerId}, {_id = house._id}, function(result)
			if result then
				player:setData("money", player:getData("money") - house.price)
				Houses.setupPlayerHouseData(player)
				--outputDebugString("Success")
				triggerClientEvent("dpCore.buy_house", resourceRoot, true)
			else
				--outputDebugString("Fail")
				triggerClientEvent("dpCore.buy_house", resourceRoot, false)
			end
		end)
	end)
end

function Houses.getUserHouseId(userId)
	if not userId then
		return false
	end
	local result = DatabaseTable.select(HOUSES_TABLE_NAME, {"_id"}, {owner_id = userId})
	if type(result) == "table" and result[1] then
		return result[1]._id
	else
		return false
	end
end

function Houses.setupPlayerHouseData(player, callback, ...)
	if not isElement(player) then
		return
	end
	player:removeData("house_id")
	player:removeData("house_data")	
	local userId = player:getData("_id")
	if not userId then
		return
	end
	local args = {...}
	return DatabaseTable.select(HOUSES_TABLE_NAME, {"_id", "data"}, {owner_id = userId}, function(result)
		if type(result) == "table" and result[1] then
			player:setData("house_id", result[1]._id)
			player:setData("house_data", fromJSON(result[1].data))
			local marker = getElementByID("house_enter_marker_" .. tostring(result[1]._id))
			if isElement(marker) then
				marker:setData("owner_id", userId)
			end			
		end
		executeCallback(callback, unpack(args))
	end)
end

function Houses.removePlayerHouse(player)
	if not isElement(player) then
		return false
	end
	local playerId = player:getData("_id")
	if not playerId then
		outputDebugString("Houses.removePlayerHouse: not authorized")
		return false
	end
	local houseId = player:getData("house_id")
	if not houseId then
		-- Нет дома
		return false
	end
	return DatabaseTable.update(HOUSES_TABLE_NAME, {owner_id = "NULL"}, {_id = houseId}, function ()
		outputDebugString("Removed house") 
		local marker = getElementByID("house_enter_marker_" .. tostring(houseId))
		if isElement(marker) then
			marker:setData("owner_id", false)
		end
		Houses.setupPlayerHouseData(player) 
	end)
end