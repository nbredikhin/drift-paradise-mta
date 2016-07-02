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
	exports.dpCore:removePlayerHouse(client)
end)