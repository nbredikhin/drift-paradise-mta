addEvent("dpCore.house_enter", true)
addEventHandler("dpCore.house_enter", resourceRoot, function (markerId)
	local houseMarker = Element.getByID(markerId)
	fadeCamera(client, true, 0.5)
	if not isElement(houseMarker) then
		return
	end
	local houseData = houseMarker:getData("house_data")
	if type(houseData) ~= "table" then
		return
	end
	client.position = Vector3(unpack(houseData.exit)) + Vector3(0, 0, 0.3)
	client.interior = houseData.interior
	client.dimension = houseMarker:getData("house_dimension")
end)

addEvent("dpCore.house_exit", true)
addEventHandler("dpCore.house_exit", resourceRoot, function (markerId)
	local houseMarker = Element.getByID(markerId)
	fadeCamera(client, true, 0.5)
	if not isElement(houseMarker) then
		return
	end
	if not houseMarker:getData("house_exit_position") then
		return 
	end

	local position = Vector3(unpack(houseMarker:getData("house_exit_position")))
	client.interior = 0
	client.dimension = 0
	client.position = position + Vector3(0, 0, 0.3)
end)
