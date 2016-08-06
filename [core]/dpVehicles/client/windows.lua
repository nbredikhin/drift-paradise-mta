-- Тонировка стёкол

local levels = {
	0.8,
	0.5,
	0.2
}

function setupWindows(vehicle)
	local level = vehicle:getData("Windows")
	if not level then
		return false
	end
	VehicleShaders.replaceWindows(vehicle, "windows", 0.5)
end

-- Обновить при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupWindows(vehicle)
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupWindows(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupWindows(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "SpoilerColor" then
		setupWindows(source)
	end
end)