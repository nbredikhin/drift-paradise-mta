local LIGHTS_COMPONENT_NAME = "LightsOpen"
local LIGHTS_STATE_DATA = "LightsState"
-- Угол поворота открытых/закрытых фар
local ANGLE_OPENED = 60
local ANGLE_CLOSED = 0
local overrideAngleOpened = {
	nissan_180sx = 40,
	toyota_ae86 = 40
}
-- Скорость открывания/закрывания фар
local LIGHTS_ROTATION_SPEED = 60
-- Автомобили, которые должны быть анимированы
-- (анимируются, автомобили, находящиеся рядом с игроком)
local animateVehicles = {}

-- Обновляет состояние компонента фар автомобиля, запускает аниацию
local function updateVehicleLightsState(vehicle)
	if not isElement(vehicle) then
		return
	end
	local state = not not vehicle:getData(LIGHTS_STATE_DATA)
	-- Угол в зависимости от состояния
	local angle = ANGLE_CLOSED
	if state then
		angle = ANGLE_OPENED
		local vehicleName = exports.dpShared:getVehicleNameFromModel(vehicle.model)
		if vehicleName and overrideAngleOpened[vehicleName] then
			angle = overrideAngleOpened[vehicleName]
		end
	end	
	local stateId = 1
	if state then
		stateId = 2
	end
	local components = vehicle:getComponents()
	local hasComponent = components[LIGHTS_COMPONENT_NAME]

	-- Если автомобиль находится рядом, запустить анимацию фар
	if hasComponent and isElementStreamedIn(vehicle) then
		-- Направление
		local direction = 1
		if not state then
			direction = -1
		end

		-- Выключить свет до начала анимации
		if stateId == 1 then
			setVehicleOverrideLights(vehicle, stateId)
		else
			local rotation = vehicle:getComponentRotation(LIGHTS_COMPONENT_NAME)
			if rotation > 300 then
				vehicle:setComponentRotation(LIGHTS_COMPONENT_NAME, ANGLE_CLOSED, 0, 0)
			end
		end
		animateVehicles[vehicle] = {targetAngle = angle, direction = direction, stateId = stateId} 
	else
		if hasComponent then
			-- Если автомобиль далеко, сразу же открыть/закрыть фары
			vehicle:setComponentRotation(LIGHTS_COMPONENT_NAME, angle, 0, 0)
		end
		setVehicleOverrideLights(vehicle, stateId)
	end
end

addEventHandler("onClientPreRender", root, function (deltaTime)
	deltaTime = deltaTime / 1000

	for vehicle, animation in pairs(animateVehicles) do
		if not isElement(vehicle) then
			animateVehicles[vehicle] = nil
		else
			local rotation = vehicle:getComponentRotation(LIGHTS_COMPONENT_NAME)
			rotation = rotation + animation.direction * LIGHTS_ROTATION_SPEED * deltaTime
			if animation.direction > 0 and rotation >= animation.targetAngle then
				rotation = animation.targetAngle
				animateVehicles[vehicle] = nil
				setVehicleOverrideLights(vehicle, animation.stateId)
			elseif animation.direction < 0 and rotation <= animation.targetAngle then
				rotation = animation.targetAngle
				animateVehicles[vehicle] = nil
				setVehicleOverrideLights(vehicle, animation.stateId)
			end
			vehicle:setComponentRotation(LIGHTS_COMPONENT_NAME, rotation, 0, 0)
		end
	end
end)

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	if name == LIGHTS_STATE_DATA then
		updateVehicleLightsState(source)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		updateVehicleLightsState(vehicle)
	end
end)

addEventHandler("onClientElementStreamedIn", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	updateVehicleLightsState(source)
end)