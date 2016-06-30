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
			local marker = exports.dpMarkers:createMarker("house", Vector3(unpack(data.enter)))
			local dimension = 50000 + i
			marker:setData("owner_id", house.owner_id)
			marker:setData("house_data", data)
			marker:setData("house_dimension", dimension)

			local exitMarker = exports.dpMarkers:createMarker("exit", Vector3(unpack(data.exit)))
			exitMarker.interior = data.interior
			exitMarker.dimension = dimension
			exitMarker:setData("house_exit_position", data.enter)

			local garageMarker = exports.dpMarkers:createMarker("garage", Vector3(unpack(data.garage)))
		end
	end)
end