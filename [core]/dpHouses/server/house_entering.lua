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
end)

addEvent("dpHouses.house_exit", true)
addEventHandler("dpHouses.house_exit", resourceRoot, function (markerId)
	local houseMarker = Element.getByID(markerId)
	fadeCamera(client, true, 0.5)
	if not isElement(houseMarker) then
		return
	end
	if not houseMarker:getData("house_exit_position") then
		return 
	end

	local position = Vector3(unpack(houseMarker:getData("house_exit_position")))
	local rotation = houseMarker:getData("house_exit_rotation")
	if rotation then
		client.rotation = Vector3(0, 0, rotation)
	end	
	client.interior = 0
	client.dimension = 0
	client.position = position
end)
