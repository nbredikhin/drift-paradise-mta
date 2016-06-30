addEvent("dpMarkers.enter", false)
addEventHandler("dpMarkers.enter", root, function ()
	if type(source:getData("house_data")) == "table" then
		local houseData = source:getData("house_data")
		localPlayer.position = Vector3(unpack(houseData.exit)) + Vector3(0, 0, 0.3)
		localPlayer.interior = houseData.interior
		localPlayer.dimension = source:getData("house_dimension")
	elseif type(source:getData("house_exit_position")) == "table" then
		local position = Vector3(unpack(source:getData("house_exit_position")))
		localPlayer.interior = 0
		localPlayer.dimension = 0
		localPlayer.position = position + Vector3(0, 0, 0.3)
	end
end)