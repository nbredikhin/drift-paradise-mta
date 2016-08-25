-- Вызов игроков на дуэль (сервер)
addEvent("dpDuels.callPlayer", true)
addEventHandler("dpDuels.callPlayer", resourceRoot, function (targetPlayer, bet)
	if not isElement(targetPlayer) then
		return false
	end
	if type(bet) ~= "number" then
		return false
	end
	-- TODO: Проверить наличие денег
	if client:getData("money") < bet then
		return
	end
	if targetPlayer:getData("money") < bet then
		return
	end
	if not client.vehicle or client.vehicle.controller ~= client then
		return false
	end
	if not targetPlayer.vehicle or targetPlayer.vehicle.controller ~= targetPlayer then
		return false
	end	

	triggerClientEvent(targetPlayer, "dpDuels.callPlayer", resourceRoot, client, bet)
end)

addEvent("dpDuels.answerCall", true)
addEventHandler("dpDuels.answerCall", resourceRoot, function (targetPlayer, status, bet)
	if not isElement(targetPlayer) then
		return false
	end
	if not status or not bet then
		triggerClientEvent(targetPlayer, "dpDuels.answerCall", resourceRoot, client, false)
		return
	end
	if not tonumber(bet) then
		return
	end
	bet = tonumber(bet)

	if not client.vehicle or client.vehicle.controller ~= client then
		return false
	end
	if not targetPlayer.vehicle or targetPlayer.vehicle.controller ~= targetPlayer then
		return false
	end	
	if client:getData("money") < bet then
		return
	end
	if targetPlayer:getData("money") < bet then
		return
	end
	client:setData("money", client:getData("money") - bet)
	targetPlayer:setData("money", client:getData("money") - bet)

	bet = bet * 2
	-- Начать дуэль

	startDuel(targetPlayer, client)
end)