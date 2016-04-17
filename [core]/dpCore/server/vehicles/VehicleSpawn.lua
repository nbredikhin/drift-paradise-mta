VehicleSpawn = {}
local dataFields = {
	"_id", "spoiler", "bodykit", "wheels", "owner_id", "mileage"
}

function VehicleSpawn.spawn(vehicleId, position, rotation, callback)
	if type(vehicleId) ~= "number" or type(position) ~= "userdata" then
		executeCallback(callback, false)
		return false
	end
	if not rotation then rotation = Vector3() end

	local success = UserVehicles.getVehicle(vehicleId, function (result)
		if not result then
			executeCallback(callback, false)
			return false
		end
		local success = Users.get(result.owner_id, { "username" }, function (user)
			if user then				
				local vehicle = Vehicle(result.model, position, rotation)
				vehicle:setColor(255, 0, 0)

				for i, name in ipairs(dataFields) do
					vehicle:setData(name, result[name])
				end
				vehicle:setData("owner_username", user.username)

				executeCallback(callback, vehicle)		
				return	
			else
				executeCallback(callback, false)
				return
			end
		end)
		if not success then
			executeCallback(callback, false)
		end
	end)
	if not success then
		executeCallback(callback, false)
		return false
	end
	return true
end

-- Защита даты 
addEventHandler("onElementDataChange", root, function(dataName, oldValue)
	if not client then
		return
	end
	if source.type == "vehicle" then
		for i, name in ipairs(dataFields) do
			if dataName == name then
				source:setData(dataName, oldValue)
				return 
			end
		end
	end
end)