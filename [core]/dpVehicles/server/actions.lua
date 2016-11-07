addEvent("dpVehicles.vehicleAction", true)
addEventHandler("dpVehicles.vehicleAction", root, function (action, value)	
	if not isElement(client.vehicle) then
		return
	end
	local vehicle = client.vehicle
	local player = client
	if vehicle.controller ~= player then
		return
	end

	if action == "lights" then
		vehicle:setData("LightsState", not vehicle:getData("LightsState"))
	elseif action == "door" and type(value) == "number" then
		local currentRatio = vehicle:getDoorOpenRatio(value)
		if currentRatio < 0.5 then
			vehicle:setDoorOpenRatio(value, 1, 500)
			vehicle:setData("DoorState" .. tostring(value), true)
			outputDebugString("DoorState" .. tostring(value))
		else
			vehicle:setDoorOpenRatio(value, 0, 500)
			vehicle:setData("DoorState" .. tostring(value), false)
		end
	elseif action == "lock" then
		for i = 2, 5 do
			vehicle:setDoorOpenRatio(i, 0, 0)
		end

		setVehicleLocked(vehicle, not isVehicleLocked(vehicle))
	elseif action == "engine" then
		setVehicleEngineState(vehicle, not getVehicleEngineState(vehicle))
	end
end)