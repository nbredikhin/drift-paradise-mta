local DEBUG = true

local _outputDebugString = outputDebugString
local function outputDebugString(...)
	if not DEBUG then
		return
	end
	_outputDebugString(...)
end

addEvent("sell_vehicleRemoved", false)
addEventHandler("sell_vehicleRemoved", resourceRoot, function (player, result)
	exports.dpCore:getPlayerVehiclesAsync(player, "sell_vehiclesListReceived")
end)

addEvent("sell_vehiclesListReceived", false)
addEventHandler("sell_vehiclesListReceived", resourceRoot, function (player, playerVehicles)
	triggerClientEvent(player, "dpGarage.updateVehiclesList", resourceRoot, playerVehicles)
end)

addEvent("dpGarage.sellVehicle", true)
addEventHandler("dpGarage.sellVehicle", resourceRoot, function (vehicleId)
	local vehicleInfo = exports.dpCore:getVehicleById(vehicleId)
	if type(vehicleInfo) ~= "table" then
		outputDebugString("Sell error: No vehicle info")
		return
	end
	if type(vehicleInfo[1]) ~= "table" then
		outputDebugString("Sell error: No vehicle info 2")
		return
	end
	vehicleInfo = vehicleInfo[1]

	local userId = client:getData("_id")
	if not userId then
		outputDebugString("Sell error: No user id")
		return
	end
	if userId ~= vehicleInfo.owner_id then
		outputDebugString("Sell error: Vehicle not owned")
		return
	end
	outputDebugString("Removing car")
	exports.dpCore:removePlayerVehicleAsync(client, vehicleId, "sell_vehicleRemoved")
end)
