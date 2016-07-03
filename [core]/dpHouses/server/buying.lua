addEvent("dpHouses.buy", true)
addEventHandler("dpHouses.buy", root, function ()
	if not isElement(source) then
		return
	end
	if not source:getData("house_price") then
		return
	end
	local houseId = source:getData("_id")
	if not houseId then
		return
	end

	exports.dpCore:buyPlayerHouse(client, houseId)
end)

addEvent("dpHouses.sell", true)
addEventHandler("dpHouses.sell", resourceRoot, function ()
	local money = client:getData("money")
	if type(money) ~= "number" then
		triggerClientEvent(client, "dpHouses.sell", resourceRoot, false)
		return
	end
	local houseId = client:getData("house_id")
	if not houseId then
		triggerClientEvent(client, "dpHouses.sell", resourceRoot, false)
		return
	end
	local marker = Element.getByID("house_enter_marker_" .. tostring(houseId))
	if not marker then
		triggerClientEvent(client, "dpHouses.sell", resourceRoot, false)
		return
	end
	local price = marker:getData("house_price")
	if type(price) ~= "number" then
		triggerClientEvent(client, "dpHouses.sell", resourceRoot, false)
		return
	end
	kickAllPlayersFromHouse(houseId)
	price = math.floor(price * HOUSE_SELL_PRICE_MUL)
	client:setData("money", money + price)
	exports.dpCore:removePlayerHouse(client)

	triggerClientEvent(client, "dpHouses.sell", resourceRoot, true)
end)