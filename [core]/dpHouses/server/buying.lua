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
		return
	end
	local houseId = client:getData("house_id")
	if not houseId then
		return
	end
	local marker = Element.getByID("house_enter_marker_" .. tostring(houseId))
	if not marker then
		return
	end
	local price = marker:getData("house_price")
	if type(price) ~= "number" then
		return
	end
	kickAllPlayersFromHouse(houseId)
	price = math.floor(price * 0.5)
	client:setData("money", money + price)
	exports.dpCore:removePlayerHouse(client)
end)