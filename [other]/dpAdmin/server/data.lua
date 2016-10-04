local function isPlayerAdmin(player)
	return true
end

addEvent("dpAdmin.requirePlayerVehiclesList", true)
addEventHandler("dpAdmin.requirePlayerVehiclesList", resourceRoot, function (player)
	if not isElement(player) then
		return
	end
	if not isPlayerAdmin(player) then
		return
	end
	local vehiclesList = exports.dpCore:getPlayerVehicles(player)
	triggerClientEvent(client, "dpAdmin.requirePlayerVehiclesList", resourceRoot, vehiclesList)
end)