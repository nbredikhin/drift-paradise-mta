function toggleVehicleParam(action, value)
	if not localPlayer.vehicle then
		return false
	end
	if localPlayer.vehicle.controller ~= localPlayer then
		return false
	end
	triggerServerEvent("dpVehicles.vehicleAction", localPlayer.vehicle, action, value)
end