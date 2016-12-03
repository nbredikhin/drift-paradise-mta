--- Синхронизация тюнинга автомобилей
-- @script dpVehicles.components

-- Компоненты, которые нужно обновлять из даты
local componentsFromData = {
	["FrontBump"] 	= true, 	-- Задний бампер
	["RearBump"]	= true, 	-- Передний бампер
	["SideSkirts"]	= true, 	-- Юбки
	["Bonnets"]		= true, 	-- Капот
	["RearLights"] 	= true, 	-- Задние фары
	["FrontLights"] = true, 	-- Передние фары
	["FrontFends"]	= true, 	-- Передние фендеры
	["RearFends"]	= true, 	-- Задние фендеры
	["Acces"]		= true, 	-- Аксессуары
}

-- Апгрейды, которые нужно обновлять из даты
local upgradesFromData = {
	["Spoilers"] = {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164}
}

local function updateVehicleTuningComponent(vehicle, componentName, forceId)
	if not isElement(vehicle) then return false end
	if type(componentName) ~= "string" or (not forceId and not componentsFromData[componentName]) then 		
		return false 
	end

	-- Скрыть все варианты компонента
	local i = 0
	while i <= 20 do
		local name = componentName .. tostring(i)		
		vehicle:setComponentVisible(name, false)
		vehicle:setComponentVisible(componentName .. "Glass" .. tostring(i), false)
		if i > 0 and not vehicle:getComponentPosition(name) then
			break
		end
		i = i + 1
	end
	-- Отобразить компонент по значению из даты (или по переданному в качестве аргрумента)
	local id = 0
	if type(forceId) == "number" then
		id = forceId
	else
		id = vehicle:getData(componentName)
		if not id then
			id = 0
		end
	end
	vehicle:setComponentVisible(componentName .. tostring(id), true)
	vehicle:setComponentVisible(componentName .. "Glass" .. tostring(id), true)
end

local function updateVehicleTuningUpgrade(vehicle, upgradeName)
	if not isElement(vehicle) then return false end
	if type(upgradeName) ~= "string" or not upgradesFromData[upgradeName] then 
		return false 
	end

	if upgradeName == "Spoilers" then
		updateVehicleTuningComponent(vehicle, upgradeName, -1)
	end

	for i, id in ipairs(upgradesFromData[upgradeName]) do
		vehicle:removeUpgrade(id)
	end

	local index = tonumber(vehicle:getData(upgradeName)) 
	if not index then
		return false
	end
	if upgradeName == "Spoilers" then
		if index > #upgradesFromData[upgradeName] then
			return updateVehicleTuningComponent(vehicle, upgradeName, index - #upgradesFromData[upgradeName])
		elseif index == 0 then
			return updateVehicleTuningComponent(vehicle, upgradeName, 0)
		else
			updateVehicleTuningComponent(vehicle, upgradeName, -1)
		end
	end
	local id = upgradesFromData[upgradeName][index]			
	if id then
		return vehicle:addUpgrade(id)
	end	
end

-- Полностью обновить тюнинг на автомобиле
local function updateVehicleTuning(vehicle)
	if not isElement(vehicle) then
		return false
	end
	for name in pairs(componentsFromData) do
		updateVehicleTuningComponent(vehicle, name)
	end
	for name in pairs(upgradesFromData) do
		updateVehicleTuningUpgrade(vehicle, name)
	end	
	return true
end

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	updateVehicleTuning(source)
end)

-- Обновить тюнинг всех автомобилей при запуске
addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		updateVehicleTuning(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "vehicle" then
		updateVehicleTuning(source)
	end
end)

-- Список названий компонентов
function getComponentsNames()
	local l = {}
	for name in pairs(componentsFromData) do
		table.insert(l, name)
	end
	for name in pairs(upgradesFromData) do
		table.insert(l, name)
	end
	table.insert(l, "WheelsF")
	table.insert(l, "WheelsR")
	table.insert(l, "Exhaust")
	return l
end