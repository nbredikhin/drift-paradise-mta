local function updateVehicleSuspension(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local value = vehicle:getData("Suspension")
	if type(value) ~= "number" then
		value = getOriginalHandling(vehicle.model).suspensionLowerLimit
	else
		value = -0.02 - value * 0.2
	end
	setVehicleHandling(vehicle, "suspensionLowerLimit", value)
end

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "Suspension" then
		updateVehicleSuspension(source)
	end
end)