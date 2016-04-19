-- Вход и выход игроков из тюнинга

function forcePlayerEnterTuning(player)
	if not isElement(player) then
		triggerClientEvent(player, "dpTuning.serverEnter", resourceRoot, false)
		return false
	end	
	if player:getData("state") then
		triggerClientEvent(player, "dpTuning.serverEnter", resourceRoot, false)
		return false
	end
	player:setData("state", "tuning")
	player.dimension = (player:getData("_id") or math.random(0, 1000)) + 5000
	triggerClientEvent(player, "dpTuning.serverEnter", resourceRoot, true)
	return true
end

function forcePlayerExitTuning(player)
	if not isElement(player) then
		return false
	end
	if player:getData("state") ~= "tuning" then
		return false
	end
	player:setData("state", false)
	player.dimension = 0
	triggerClientEvent(player, "dpTuning.serverExit", resourceRoot)
	return true
end

addEvent("dpTuning.clientEnter", true)
addEventHandler("dpTuning.clientEnter", resourceRoot, function ()
	forcePlayerEnterTuning(client)
end)

addEvent("dpTuning.clientExit", true)
addEventHandler("dpTuning.clientExit", resourceRoot, function ()
	if not forcePlayerExitTuning(client) then
		triggerClientEvent(player, "dpTuning.serverExit", resourceRoot)
	end
end)

addEventHandler("onResourceStop", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		forcePlayerExitTuning(player)
	end
end)