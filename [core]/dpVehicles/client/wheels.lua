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

local shaderReflectionTexture

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
			wheelSize = math.max(0.1, wheelSize)
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
					wheelColor[i] = wheelColor[i] / 255 
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
		if wheel.object.dimension ~= vehicle.dimension then
			wheel.object.dimension = vehicle.dimension
		end
		-- Отобразить стандартные колёса по умолчанию
		vehicle:setComponentVisible(name, true)
		-- Сохранить начальную позицию колёс
		local x, y, z = vehicle:getComponentPosition(name)
		wheel.position = Vector3(x, y, z)
		-- Шейдер
		wheel.shader = DxShader("assets/shaders/wheel.fx", 0, 20, false, "object")
		wheel.shader:setValue("sReflectionTexture", shaderReflectionTexture)

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
	shaderReflectionTexture = dxCreateTexture("assets/wheels/reflection_cubemap.dds")
	
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleWheels(vehicle)
	end
end)

local function getDriftAngle(vehicle)
	if vehicle.velocity.length < 0.12 then
		return 0
	end

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.deg(math.atan2(det, dot))
	if math.abs(angle) > 100 then
		return 0
	end
	return angle
end

local function wrapAngle(value)
	if not value then
		return 0
	end
	value = math.mod(value, 360)
	if value < 0 then
		value = value + 360
	end
	return value
end

local localVehicleSteering = {}
for i, name in ipairs(wheelsNames) do
	localVehicleSteering[name] = 0
end

local steeringSmoothing = 0.7

-- Обновление положения колёс
addEventHandler("onClientPreRender", root, function ()
	if getKeyState("space") then
		steeringSmoothing = 0.1
	else
		steeringSmoothing = 0.2
	end
	for vehicle, wheels in pairs(vehicleWheels) do
		local velocity = vehicle.velocity
		local direction = vehicle.matrix.forward
		local driftAngle = getDriftAngle(vehicle)
		if driftAngle > 50 then
			driftAngle = 50
		end
		local driftMul = 1 - math.min(1, math.abs(driftAngle) / 66)
		local steeringMul = 1
		local isLocalVehicle = vehicle == localPlayer.vehicle
		if isLocalVehicle and getKeyState("space") then
			steeringMul = 0
		end
		for name, wheel in pairs(wheels) do
			if wheel.custom then
				local rx, ry, rz = vehicle:getComponentRotation(name)
				local position = vehicle.matrix:transformPosition(wheel.position)
				local steering = 0
				if name == "wheel_rf_dummy" then
					local angleOffset = wrapAngle(rz + 180) - 180
					steering = driftAngle * 0.6 + angleOffset * driftMul * steeringMul
				elseif name == "wheel_lf_dummy" then
					local angleOffset = rz - 180
					steering = driftAngle * 0.6 + angleOffset * driftMul  * steeringMul + 180
				else
					steering = rz
				end
				local currentSteering = steering
				if isLocalVehicle then
					localVehicleSteering[name] = localVehicleSteering[name] + (steering - localVehicleSteering[name]) * steeringSmoothing
					currentSteering = localVehicleSteering[name]
				end
				wheel.object.alpha = vehicle.alpha
				wheel.object.position = position
				wheel.object.rotation = vehicle.rotation
				if wheel.object.dimension ~= vehicle.dimension then
					wheel.object.dimension = vehicle.dimension
				end

				wheel.shader:setValue("sRotationX", rx)
				wheel.shader:setValue("sRotationZ", currentSteering)
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