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

addEventHandler("onPlayerLogin", root, function ()
	if isPlayerAdmin(source) then
		source:setData("aclGroup", "admin")
	else
		source:setData("aclGroup", "user")
	end
end)

addEventHandler("onPlayerLogout", root, function ()
	source:setData("aclGroup", "guest")
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, p in ipairs(getElementsByType("player")) do
		if isPlayerAdmin(p) then
			p:setData("aclGroup", "admin")
		end
	end
end)