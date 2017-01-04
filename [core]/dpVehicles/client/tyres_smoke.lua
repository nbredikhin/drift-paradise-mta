-- Дым из-под колёс при дрифте
local CONFIG_PROPERTY_NAME = "graphics.tyres_smoke"

local smokeVehicles = {}

local MIN_DRIFT_ANGLE = 5
local MAX_DRIFT_ANGLE = 65

local function detectVehicleDrift(vehicle)
	local velocity = vehicle.velocity
	local direction = vehicle.matrix.forward

	if velocity.length < 0.12 then 
		return 0, false
	end
	velocity = velocity:getNormalized()

	local angle = math.abs(math.deg(math.acos(velocity:dot(direction) / (velocity.length * direction.length))))
	if angle > MIN_DRIFT_ANGLE and angle < 110 then
		return angle
	end
	return false
end

local function checkVehicleOnGround(vehicle)
	local ox, oy, oz = vehicle:getComponentPosition("wheel_lb_dummy")
	local vehicleMatrix = vehicle.matrix
	local centerPosition1 = vehicleMatrix:transformPosition(0, oy, oz)
	local centerPosition2 = vehicleMatrix:transformPosition(0, oy, oz - 0.5)
	return not isLineOfSightClear(centerPosition1, centerPosition2, true, false, false, true, false)
end

local function update()
	for vehicle, emitters in pairs(smokeVehicles) do
		-- Left wheel
		local ox, oy, oz = vehicle:getComponentPosition("wheel_lb_dummy")
		local vehicleMatrix = vehicle.matrix
		local leftPosition = vehicleMatrix:transformPosition(ox, oy, oz)						
		exports.dpParticles:setEmitterPosition(emitters.leftEmitter, leftPosition.x, leftPosition.y, leftPosition.z)
		-- Right wheel
		ox, oy, oz = vehicle:getComponentPosition("wheel_rb_dummy")
		local rightPosition = vehicleMatrix:transformPosition(ox, oy, oz)
		exports.dpParticles:setEmitterPosition(emitters.rightEmitter, rightPosition.x, rightPosition.y, rightPosition.z)

		exports.dpParticles:setEmitterOption(emitters.leftEmitter, "density", 0)
		exports.dpParticles:setEmitterOption(emitters.rightEmitter, "density", 0)

		if vehicle.dimension == localPlayer.dimension and vehicle.onGround and checkVehicleOnGround(vehicle) then
			local driftAngle = detectVehicleDrift(vehicle)
			if driftAngle then
				local smokeMul = (driftAngle - MIN_DRIFT_ANGLE) / MAX_DRIFT_ANGLE
				if smokeMul > 1 then
					smokeMul = 1
				end
				local density = 0
				if smokeMul > 0 then
					density = 1
				end
				exports.dpParticles:setEmitterOption(emitters.leftEmitter, "density", density)
				exports.dpParticles:setEmitterOption(emitters.rightEmitter, "density", density)

				local sizeMul = 0.7 + smokeMul * 0.3
				local startSize = {1 * sizeMul, 2 * sizeMul}
				exports.dpParticles:setEmitterOption(emitters.leftEmitter, "startSize", startSize)
				exports.dpParticles:setEmitterOption(emitters.rightEmitter, "startSize", startSize)

				local endSize = {6 * sizeMul, 8 * sizeMul}
				exports.dpParticles:setEmitterOption(emitters.leftEmitter, "endSize", endSize)
				exports.dpParticles:setEmitterOption(emitters.rightEmitter, "endSize", endSize)

				local delay = 0.025 + (1 - smokeMul) * 0.03
				exports.dpParticles:setEmitterOption(emitters.leftEmitter, "delay", delay)
				exports.dpParticles:setEmitterOption(emitters.rightEmitter, "delay", delay)

				local alpha = smokeMul * 0.8 + 0.2 
				exports.dpParticles:setEmitterOption(emitters.leftEmitter, "alpha", alpha)
				exports.dpParticles:setEmitterOption(emitters.rightEmitter, "alpha", alpha)

				local color = vehicle:getData("SmokeColor")
				if color then
					exports.dpParticles:setEmitterOption(emitters.leftEmitter, "r", color[1])
					exports.dpParticles:setEmitterOption(emitters.rightEmitter, "r", color[1])

					exports.dpParticles:setEmitterOption(emitters.leftEmitter, "g", color[2])
					exports.dpParticles:setEmitterOption(emitters.rightEmitter, "g", color[2])

					exports.dpParticles:setEmitterOption(emitters.leftEmitter, "b", color[3])
					exports.dpParticles:setEmitterOption(emitters.rightEmitter, "b", color[3])										
				end
			end
		end
	end
end

local function addVehicleSmoke(vehicle)
	if not exports.dpConfig:getProperty(CONFIG_PROPERTY_NAME) then
		return
	end
	if not isElement(vehicle) or smokeVehicles[vehicle] then
		return false
	end
	local options = {
		x = vehicle.position.x,
		y = vehicle.position.y,
		z = vehicle.position.z,

		density = 1,
		delay = 0.025,
		lifetime = {2, 3},
		fadeInAt = 0.1,

		startSize = 0,
		endSize = 0,

		forceZ = 1.2,
	}
	local leftEmitter = exports.dpParticles:createEmitter(options)
	local rightEmitter = exports.dpParticles:createEmitter(options)
	smokeVehicles[vehicle] = {
		leftEmitter = leftEmitter,
		rightEmitter = rightEmitter
	}
	return true
end

local function removeVehicleSmoke(vehicle)
	if not smokeVehicles[vehicle] then
		return false
	end
	exports.dpParticles:destroyEmitter(smokeVehicles[vehicle].leftEmitter)
	exports.dpParticles:destroyEmitter(smokeVehicles[vehicle].rightEmitter)
	smokeVehicles[vehicle] = nil
	return true
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, v in ipairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(v) then
			addVehicleSmoke(v)
		end
	end

	addEventHandler("onClientPreRender", root, update)
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "vehicle" then
		addVehicleSmoke(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if source.type == "vehicle" then
		removeVehicleSmoke(source)
	end
end)

addEventHandler("onClientElementDestroy", root, function ()
	if source.type == "vehicle" then
		removeVehicleSmoke(source)
	end
end)

addEvent("onClientVehicleCreated", true)
addEventHandler("onClientVehicleCreated", root, function ()
	local vehicle = source
	setTimer(function()
		if isElement(vehicle) and isElementStreamedIn(vehicle) then
			addVehicleSmoke(vehicle)
		end
	end, 1000, 1)
end)

addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		for i, v in ipairs(getElementsByType("vehicle")) do
			if value and isElementStreamedIn(v) then
				addVehicleSmoke(v)
			else
				removeVehicleSmoke(v)
			end
		end
	end
end)