function switchHandling()
	if localPlayer.vehicle:getData("activeHandling") == "street" then
		if localPlayer.vehicle:getData("DriftHandling") == 0 then
			exports.dpChat:message("global", "You don't have drift upgrade installed!", 255, 0, 0)
		else
			exports.dpChat:message("global", "Switching to drift handling", 0, 255, 0)
		end
	else
		exports.dpChat:message("global", "Switching to street handling", 0, 255, 0)
	end
	triggerServerEvent("switchPlayerHandling", resourceRoot)
end

bindKey("2", "down", function ()
	if not localPlayer.vehicle then
		return 
	end
	switchHandling()
end)