addEvent("dpGarage.previewHandling", true)
addEventHandler("dpGarage.previewHandling", resourceRoot, function (name, value)
	local vehicle = client:getData("garageVehicle")
	if not isElement(vehicle) then
		return
	end
	vehicle:setData(name, value)
end)