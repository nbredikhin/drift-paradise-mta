function setupSpoilerColor(vehicle)
	local color = vehicle:getData("SpoilerColor")
	if type(color) ~= "table" then
		return
	end
	local r, g, b = unpack(color)
	VehicleShaders.replaceColor(vehicle, "*spoiler*", r, g, b)
end

-- Обновить текстуры всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	selectionTexture = dxCreateTexture("assets/selection.png")
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupSpoilerColor(vehicle)
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupSpoilerColor(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupSpoilerColor(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "SpoilerColor" then
		setupSpoilerColor(source)
	end
end)