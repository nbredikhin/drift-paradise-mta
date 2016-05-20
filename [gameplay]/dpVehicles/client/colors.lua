---------------------------------------
-- 		Синхронизация цветов         --
---------------------------------------

local function updateVehicleBodyColor(vehicle)
	if not isElement(vehicle) then
		return
	end	
	local newColor = vehicle:getData("BodyColor")
	if type(newColor) ~= "table" or #newColor < 3 then
		return
	end

	local currentColor = {vehicle:getColor(true)}
	for i = 1, 3 do
		currentColor[i] = newColor[i]
	end
	vehicle:setColor(unpack(currentColor))
end

local function updateVehicleWheelsColor(vehicle)
	if not isElement(vehicle) then
		return
	end	
	local newColor = vehicle:getData("WheelsColor")
	if type(newColor) ~= "table" or #newColor < 3 then
		return
	end

	local currentColor = {vehicle:getColor(true)}
	for i = 1, 3 do
		currentColor[3 + i] = newColor[i]
		outputChatBox(newColor[i])
	end
	vehicle:setColor(unpack(currentColor))
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
	updateVehicleWheelsColor(vehicle)
	updateVehicleSpoilerColor(vehicle)
end

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	if name == "BodyColor" then
		updateVehicleBodyColor(source)
	elseif name == "WheelsColor" then
		updateVehicleWheelsColor(source)
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