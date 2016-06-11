-- Кастомизация колёса автомобиля, синхронизация

local vehicleWheels = {}

-- Передние/задние колёса
local frontWheels = {
	["wheel_lf_dummy"] = true,
	["wheel_rf_dummy"] = true
}
local rearWheels = {
	["wheel_lb_dummy"] = true,
	["wheel_rb_dummy"] = true
}

-- Все колёса
local wheelsNames = {"wheel_rf_dummy", "wheel_lf_dummy", "wheel_rb_dummy", "wheel_lb_dummy"}

-- Модели объектов колёс
local wheelsModels = {1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098}

-- Дата, изменение которой вызывает обновление колёс
local dataNames = {
	["WheelsWidthF"] 	= true, 
	["WheelsWidthR"] 	= true, 
	["WheelsAngleF"] 	= true, 
	["WheelsAngleR"] 	= true, 
	["Wheels"] 			= true, 
	["WheelsF"] 		= true, 
	["WheelsR"] 		= true, 
	["WheelsSize"] 		= true,
	["WheelsColorR"] 	= true,
	["WheelsColorF"] 	= true,
}

-- Удаление кастомных колёс и шейдера
local function removeVehicleWheels(vehicle)
	if not vehicleWheels[vehicle] then
		return false
	end
	local wheels = vehicleWheels[vehicle]
	for name, wheel in pairs(wheels) do
		-- Получение ID колеса из даты
		-- Отобразить
		vehicle:setComponentVisible(name, true)
		-- Обновить размер
		if isElement(wheel.object) then
			destroyElement(wheel.object)
		end
		-- Обновить развал и толщину
		if isElement(wheel.shader) then
			destroyElement(wheel.shader)
		end
		wheels[name] = nil
	end
	vehicleWheels[vehicle] = nil
	return true
end

-- Обновление колёс из даты без пересоздания шейдера
local function updateVehicleWheels(vehicle)
	if not vehicleWheels[vehicle] then
		return false
	end
	local wheels = vehicleWheels[vehicle]
	for name, wheel in pairs(wheels) do
		-- Получение ID колеса из даты
		local wheelId = vehicle:getData("WheelsF")
		if rearWheels[name] then
			wheelId = vehicle:getData("WheelsR")
		end

		-- Если кастомные колёса - применить настройки
		if type(wheelId) == "number" and wheelId > 0 then
			-- Получение параметров колеса из даты
			local wheelSize = vehicle:getData("WheelsSize") or 0.7
			wheelSize = math.max(0.63, wheelSize)
			local wheelRazval = -10
			local wheelWidth = 0.15
			local wheelColor = {255, 255, 255}
			if frontWheels[name] then
				wheelWidth = vehicle:getData("WheelsWidthF") or 0
				wheelRazval = vehicle:getData("WheelsAngleF") or 0
				wheelColor = vehicle:getData("WheelsColorF")
			else
				wheelWidth = vehicle:getData("WheelsWidthR") or 0 
				wheelRazval = vehicle:getData("WheelsAngleR") or 0
				wheelColor = vehicle:getData("WheelsColorR")
			end	
			if not wheelColor then
				wheelColor = {255, 255, 255}
			end
			wheel.custom = true
			-- Обновить размер
			if isElement(wheel.object) then
				wheel.object.alpha = 255
				wheel.object.model = wheelsModels[wheelId]
				wheel.object.scale = wheelSize
			end
			-- Обновить развал и толщину
			if isElement(wheel.shader) then
				wheel.shader:setValue("sRazval", wheelRazval)
				wheel.shader:setValue("sWidth", wheelWidth)
				-- Цвет колеса
				for i = 1, 3 do
					wheelColor[i] = wheelColor[i] / 255 * 2 
				end
				wheelColor[4] = 1
				wheel.shader:setValue("sColor", wheelColor)
			end
			wheels[name] = wheel
		else
			wheel.custom = false
			wheel.object.alpha = 0
		end
		-- Скрыть/отобразить стандартное колесо
		setVehicleComponentVisible(vehicle, name, not wheel.custom)		
	end
	return true
end

-- Создание кастомных колёс на автомобиле
local function setupVehicleWheels(vehicle)
	if not isElement(vehicle) then
		return false
	end
	if not isElementStreamedIn(vehicle) then
		return false
	end
	if vehicleWheels[vehicle] then
		return false
	end
	local wheels = {}
	for i, name in ipairs(wheelsNames) do
		local wheel = {}
		-- Создать объект колеса
		wheel.object = createObject(1025, 0, 0, -10)
		wheel.object.alpha = 0
		wheel.object:setCollisionsEnabled(false)
		-- Отобразить стандартные колёса по умолчанию
		vehicle:setComponentVisible(name, true)
		-- Сохранить начальную позицию колёс
		local x, y, z = vehicle:getComponentPosition(name)
		wheel.position = Vector3(x, y, z)
		-- Шейдер
		wheel.shader = DxShader("assets/shaders/wheel.fx")
		wheel.shader:applyToWorldTexture("*", wheel.object)

		wheels[name] = wheel
	end
	vehicleWheels[vehicle] = wheels
	updateVehicleWheels(vehicle)
	return true
end

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	setupVehicleWheels(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	removeVehicleWheels(source)
end)

addEventHandler("onClientElementDestroy", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	removeVehicleWheels(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleWheels(vehicle)
	end
end)

-- Обновление положения колёс
addEventHandler("onClientPreRender", root, function ()
	for vehicle, wheels in pairs(vehicleWheels) do
		for name, wheel in pairs(wheels) do
			if wheel.custom then
				local rx, ry, rz = vehicle:getComponentRotation(name)
				local position = vehicle.matrix:transformPosition(wheel.position)
				wheel.object.position = position
				wheel.object.rotation = vehicle.rotation

				wheel.shader:setValue("sRotationX", rx)
				wheel.shader:setValue("sRotationZ", rz)
				wheel.shader:setValue("sAxis", {vehicle.matrix.up.x, vehicle.matrix.up.y, vehicle.matrix.up.z})	
			end	
			vehicle:setComponentVisible(name, not wheel.custom)
		end
	end
end)

-- Обновление позиции колёс 
addEventHandler("onClientHUDRender", root, function ()
	for vehicle, wheels in pairs(vehicleWheels) do
		for name, wheel in pairs(wheels) do
			local wheelRazval = 0
			if frontWheels[name] then
				wheelRazval = vehicle:getData("WheelsAngleF") or 0
			else
				wheelRazval = vehicle:getData("WheelsAngleR") or 0
			end	

			if wheel.custom then
				local x, y, z = vehicle:getComponentPosition(name)
				wheel.position = Vector3(x, y, z + wheelRazval / 800)
			end
		end
	end
end)

-- Обновление позиции колёс 
addEventHandler("onClientRender", root, function ()
	for vehicle, wheels in pairs(vehicleWheels) do
		for name, wheel in pairs(wheels) do
			vehicle:setComponentVisible(name, not wheel.custom)
		end			
	end
end)

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	if dataNames[name] then
		updateVehicleWheels(source)
	end
end)