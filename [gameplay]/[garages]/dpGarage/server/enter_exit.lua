-- Вход и выход игроков из гаража

function forcePlayerEnterGarage(player)
	if not isElement(player) then
		triggerClientEvent(player, "dpGarage.serverEnter", resourceRoot, false)
		return false
	end	
	if player:getData("state") then
		triggerClientEvent(player, "dpGarage.serverEnter", resourceRoot, false)
		return false
	end
	player:setData("state", "garage")
	local dimension = (player:getData("_id") or math.random(0, 1000)) + 5000
	player.dimension = dimension
	player.vehicle.dimension = dimension
	triggerClientEvent(player, "dpGarage.serverEnter", resourceRoot, true)
	return true
end

function forcePlayerExitGarage(player)
	if not isElement(player) then
		return false
	end
	if player:getData("state") ~= "garage" then
		return false
	end
	player:setData("state", false)
	player.dimension = 0
	player.vehicle.dimension = 0
	triggerClientEvent(player, "dpGarage.serverExit", resourceRoot)
	return true
end

addEvent("dpGarage.clientEnter", true)
addEventHandler("dpGarage.clientEnter", resourceRoot, function ()
	forcePlayerEnterGarage(client)
end)

addEvent("dpGarage.clientExit", true)
addEventHandler("dpGarage.clientExit", resourceRoot, function ()
	if not forcePlayerExitGarage(client) then
		triggerClientEvent(player, "dpGarage.serverExit", resourceRoot)
	end
end)

addEventHandler("onResourceStop", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		forcePlayerExitGarage(player)
	end
end)