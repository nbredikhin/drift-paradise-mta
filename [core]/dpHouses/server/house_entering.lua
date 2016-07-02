addEvent("dpHouses.house_enter", true)
addEventHandler("dpHouses.house_enter", resourceRoot, function (markerId)
	local houseMarker = Element.getByID(markerId)
	fadeCamera(client, true, 0.5)
	if not isElement(houseMarker) then
		return
	end
	local houseData = houseMarker:getData("house_data")
	if type(houseData) ~= "table" then
		return
	end
	client.position = Vector3(unpack(houseData.exit))
	if houseData.exit_rotation then
		client.rotation = Vector3(0, 0, houseData.exit_rotation)
	end
	client.interior = houseData.interior
	client.dimension = houseMarker:getData("house_dimension")
	client:setData("activeMap", "house")
	client:setData("currentHouse", houseMarker:getData("_id"))
end)

function removePlayerFromHouseById(player, houseId)
	removePlayerFromHouse(player, "house_exit_marker_" .. tostring(houseId))
end

function kickAllPlayersFromHouse(houseId, excludePlayer)
	if not houseId then 
		return
	end
	for i, v in ipairs(getElementsByType("player")) do
		if (excludePlayer and v ~= excludePlayer) or (not excludePlayer) then
			local activeMap = v:getData("activeMap")
			if not activeMap then activeMap = "" end
			local currentHouse = v:getData("currentHouse")
			if not currentHouse then currentHouse = 0 end
			if activeMap == "house" and currentHouse == houseId then
				removePlayerFromHouseById(v, houseId)
			end
		end
	end
end

function removePlayerFromHouse(player, houseMarkerId)
	local houseMarker = Element.getByID(houseMarkerId)
	fadeCamera(player, true, 0.5)
	if not isElement(houseMarker) then
		return
	end
	if not houseMarker:getData("house_exit_position") then
		return 
	end

	local position = Vector3(unpack(houseMarker:getData("house_exit_position")))
	local rotation = houseMarker:getData("house_exit_rotation")
	if rotation then
		player.rotation = Vector3(0, 0, rotation)
	end	
	player.interior = 0
	player.dimension = 0
	player.position = position

	player:setData("activeMap", false)
end

addEvent("dpHouses.house_exit", true)
addEventHandler("dpHouses.house_exit", resourceRoot, function (markerId)
	removePlayerFromHouse(client, markerId)
end)


addEvent("dpHouses.knock", true)
addEventHandler("dpHouses.knock", resourceRoot, function (houseId)
	triggerClientEvent("dpHouses.knock", client, houseId)
end)

addEvent("dpHouses.kickPlayers", true)
addEventHandler("dpHouses.kickPlayers", resourceRoot, function ()
	local houseId = client:getData("house_id")
	if type(houseId) ~= "number" then
		return
	end

	kickAllPlayersFromHouse(houseId, client)
end)