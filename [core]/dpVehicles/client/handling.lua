bindKey("2", "down", function ()
	if not localPlayer.vehicle then
		return 
	end
	triggerServerEvent("switch_handling_pls", resourceRoot)
end)