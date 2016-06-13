--- Синхронизация цветов автомобилей
-- @script dpVehicles.colors

local function updateVehicleBodyColor(vehicle)
	if not isElement(vehicle) then
		return
	end
	-- Красим машину в белый, т. к. цвет определяется текстурой
	vehicle:setColor(255, 255, 255)
end

local function updateVehicleSpoilerColor(vehicle)
	-- TODO
end

-- Обновить все цвета автомобиля
local function updateAllVehicleColors(vehicle)
	if not isElement(vehicle) then
		return
	end
	updateVehicleBodyColor(vehicle)
	updateVehicleSpoilerColor(vehicle)
end

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	if name == "BodyColor" then
		updateVehicleBodyColor(source)
	elseif name == "SpoilerColor" then
		updateVehicleSpoilerColor(source)
	end
end)

-- Обновить цвет всех автомобилей при запуске
addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		updateAllVehicleColors(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "vehicle" then
		updateAllVehicleColors(source)
	end
end)