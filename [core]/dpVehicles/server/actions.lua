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
	elseif action == "engine" then
		setVehicleEngineState(vehicle, not getVehicleEngineState(vehicle))
	elseif action == "lock" then
		vehicle:setData("locked", not vehicle:getData("locked"))
	end
end)

addEventHandler("onVehicleStartEnter", root, function (player)
	local vehicle = source
	if vehicle:getData("locked") then
		if vehicle:getData("owner_id") ~= player:getData("_id") then
			cancelEvent()
		end
	end
end)