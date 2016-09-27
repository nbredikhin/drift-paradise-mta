local function setupVehicleHandling(vehicle)
	if not isElement(vehicle) then
		return false
	end
	local vehicleName = exports.dpShared:getVehicleNameFromModel(vehicle.model)
	local activeHandling = vehicle:getData("activeHandling")
	if not activeHandling then
		activeHandling = "street"
	end
	local handlingsTable = getVehicleHandlingTable(vehicleName, activeHandling, 1)
	if not handlingsTable then
		return false
	end
	setVehicleHandling(vehicle, true)
	for k, v in pairs(handlingsTable) do
		setVehicleHandling(vehicle, k, v)
	end
end

addEvent("onVehicleCreated", false)
addEventHandler("onVehicleCreated", root, function () 
	if source.type ~= "vehicle" then
		return
	end
	setupVehicleHandling(source)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, v in ipairs(getElementsByType("vehicle")) do
		v:setData("activeHandling", "street")
		setupVehicleHandling(v)
	end
end)

addEventHandler("onElementDataChange", root, function (dataName)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "activeHandling" then
		setupVehicleHandling(source)
	end
end)

addEvent("switch_handling_pls", true)
addEventHandler("switch_handling_pls", resourceRoot, function ()
	if client.vehicle:getData("activeHandling") == "street" then
		client.vehicle:setData("activeHandling", "drift", true)
	else
		client.vehicle:setData("activeHandling", "street", true)
	end
end)