local dataToComponents = {
	["RearBump"] = true,
	["SideSkirts"] = true,
	["Bonnets"] = true,
	["FrontBump"] = true,
	["RearLights"] = true,
	["FrontFends"] = true,
	["RearFends"] = true
}
local dataToUpgrades = {
	["spoiler"] = { 
		1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 
		1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164
	},
	["wheels"] = {
		1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080,
		1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098
	}
}

function reloadVehicleUpgrades(vehicle)
	for componentName, _ in pairs(dataToComponents) do
		for i = 0, 100 do
			vehicle:setComponentVisible(componentName .. tostring(i), false)
		end
		local currentValue = vehicle:getData(componentName)
		if not currentValue then
			currentValue = 0
		end
		vehicle:setComponentVisible(componentName .. currentValue, true)
	end

	for i = 1000, 1193 do
		vehicle:removeUpgrade(i)
	end
	for dataName, upgradesList in pairs(dataToUpgrades) do
		local currentValue = vehicle:getData(dataName)
		if currentValue and currentValue > 0 then
			vehicle:addUpgrade(upgradesList[currentValue])
		end
	end
end

addEventHandler("onClientElementDataChange", root, function (dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	local vehicle = source
	local newValue = source:getData(dataName)
	if not newValue then
		newValue = 0
	end
	local componentName = dataName
	if dataToComponents[componentName] then
		-- Если был старый компонент, скрыть его
		if oldValue then
			vehicle:setComponentVisible(componentName .. tostring(oldValue), false)
		end
		-- if newValue < 1 then
		-- 	newValue = 1
		-- end

		-- Отобразить новый компонент
		vehicle:setComponentVisible(componentName .. tostring(newValue), true)
	end
	local upgradesList = dataToUpgrades[dataName]
	if upgradesList then
		-- Снять старый апгрейд
		if type(oldValue) == "number" and oldValue > 0 then
			vehicle:removeUpgrade(upgradesList[oldValue])
		end
		-- Поставить новый апгрейд
		if newValue > 0 then
			vehicle:addUpgrade(upgradesList[newValue])
		end	
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	reloadVehicleUpgrades(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		reloadVehicleUpgrades(vehicle)
	end
end)