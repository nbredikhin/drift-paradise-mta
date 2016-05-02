VehicleSpawn = {}
local EXPLODED_VEHICLE_DESTROY_TIMEOUT = 5000
local dataFields = {
	"_id", "spoiler", "bodykit", "wheels", "owner_id", "mileage"
}

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
	return vehicle
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

addEventHandler("onVehicleExplode", root, function()
	local vehicle = source
	setTimer(function ()
		if isElement(vehicle) then
			destroyElement(vehicle)
		end
	end, EXPLODED_VEHICLE_DESTROY_TIMEOUT, 1)
end)