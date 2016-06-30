addEvent("dpMarkers.enter", false)
addEventHandler("dpMarkers.enter", root, function ()
	local marker = source
	if type(marker:getData("house_data")) == "table" then
		setTimer(function ()
			triggerServerEvent("dpCore.house_enter", resourceRoot, marker.id)
		end, 500, 1)
		fadeCamera(false, 0.5)
	elseif type(marker:getData("house_exit_position")) == "table" then
		setTimer(function ()
			triggerServerEvent("dpCore.house_exit", resourceRoot, marker.id)
		end, 500, 1)
		fadeCamera(false, 0.5)		
	end
end)