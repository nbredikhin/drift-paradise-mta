local dataToComponents = {
	["RearBump"] = true,
	["SideSkirts"] = true,
	["Bonnets"] = true,
	["FrontBump"] = true,
	["RearLights"] = true,
	["FrontFends"] = true,
	["RearFends"] = true,
	["Exhaust"] = true,
	["Spoilers"] = true,
	["Acces"] = true
}
local dataToUpgrades = {
	["Spoilers"] = { 
		1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 
		1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164
	},
	["wheels"] = {
		1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080,
		1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098
	}
}
local wheelsComponents = {
	"wheel_lf_dummy", "wheel_rf_dummy", "wheel_rb_dummy", "wheel_lb_dummy"
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
		if currentValue and upgradesList[currentValue] then
			vehicle:addUpgrade(upgradesList[currentValue])
		end
	end

	local wheelsOffset = vehicle:getData("wheels_offset")
	if type(wheelsOffset) == "number" then
		local mul = 1 + math.max(0, math.min(wheelsOffset, 1)) / 10
		for i, name in ipairs(wheelsComponents) do
			resetVehicleComponentPosition(vehicle, name)
			local x, y, z = vehicle:getComponentPosition(name)
			vehicle:setComponentPosition(name, x * mul, y, z)
			vehicle:setComponentVisible(name, false)

			local x, y, z = vehicle:getComponentPosition(name)
			local rx, ry, rz = vehicle:getComponentRotation(name)
			local wheelObject = createObject(1074, vehicle.position)
			wheelObject:setScale(0.7)
			attachElements(wheelObject, vehicle, x, y, z, 0, ry, rz)
			vehicle:setData(name, wheelObject)
		end
	end
end

addEventHandler("onClientPreRender", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		for i, name in ipairs(wheelsComponents) do
			local wheelObject = vehicle:getData(name)	
			if isElement(wheelObject) then	
				local x, y, z = vehicle:getComponentPosition(name)
				local rx, ry, rz = vehicle:getComponentRotation(name)				
				setElementAttachedOffsets(wheelObject, x, y, z, 0, 0, 0)
				wheelObject:setRotation(rx, ry - 10, rz + vehicle.rotation.z)
			end
		end
	end
end)

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
		local upgradesList = dataToUpgrades[dataName]
		local oldValue = oldValue
		local newValue = newValue
		if upgradesList then
			if oldValue then
				oldValue = oldValue - #upgradesList
			end
			newValue = newValue - #upgradesList
		end
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
		if type(oldValue) == "number" and upgradesList[oldValue] then
			vehicle:removeUpgrade(upgradesList[oldValue])
		end
		-- Поставить новый апгрейд
		if type(newValue) == "number" and upgradesList[newValue] then
			vehicle:addUpgrade(upgradesList[newValue])
		end	
	end

	if dataName == "wheels_offset" then
		local mul = 1 + math.max(0, math.min(newValue, 3)) / 10
		for i, name in ipairs(wheelsComponents) do
			resetVehicleComponentPosition(vehicle, name)
			local x, y, z = vehicle:getComponentPosition(name)
			vehicle:setComponentPosition(name, x * mul, y, z)
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

addCommandHandler("tunshow", function (cmd, name, id)
	if not name or not id then
		outputChatBox("Чота ни так")
	end
	id = tonumber(id)
	if not id then
		outputChatBox("Ну ты чо епта")
		return 
	end
	localPlayer.vehicle:setData(name, id)
end)