addEvent("dpAdmin.requirePlayerVehiclesList", true)
addEventHandler("dpAdmin.requirePlayerVehiclesList", resourceRoot, function (player)
	if not isElement(player) then
		return
	end
	if not isPlayerAdmin(client) then
		return
	end
	local vehiclesList = exports.dpCore:getPlayerVehicles(player)
	triggerClientEvent(client, "dpAdmin.requirePlayerVehiclesList", resourceRoot, vehiclesList)
end)

addEvent("dpAdmin.requireGiftKeysList", true)
addEventHandler("dpAdmin.requireGiftKeysList", resourceRoot, function ()
	if not isPlayerAdmin(client) then
		return
	end
	local keysList = exports.dpCore:getGiftKeys()
	triggerClientEvent(client, "dpAdmin.requireGiftKeysList", resourceRoot, keysList)
end)

addEvent("dpAdmin.createGiftKeys", true)
addEventHandler("dpAdmin.createGiftKeys", resourceRoot, function (options, count)
	if not isPlayerAdmin(client) then
		return
	end
	if type(options) ~= "table" then
		return 
	end
	if type(count) ~= "number" or count <= 0 then
		return
	end
	count = math.min(1000, count)

	local keysList = {}
	for i = 1, count do
		exports.dpCore:createGiftKey(options)
	end
	triggerClientEvent(client, "dpAdmin.updatedKeys", resourceRoot)
end)

addEvent("dpAdmin.removeGiftKeys", true)
addEventHandler("dpAdmin.removeGiftKeys", resourceRoot, function (keys)
	if type(keys) ~= "table" then
		return
	end
	if not isPlayerAdmin(client) then
		return
	end	
	for i, key in ipairs(keys) do
		exports.dpCore:removeGiftKey(key)
	end
	triggerClientEvent(client, "dpAdmin.updatedKeys", resourceRoot)
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