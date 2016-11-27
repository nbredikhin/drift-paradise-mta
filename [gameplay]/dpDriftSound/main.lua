local MIN_DRIFT_SPEED = 0.02
local MIN_DRIFT_ANGLE = 10

local MAX_VOLUME = 1
local soundPath = "sound.wav"
local sound
local targetVolume = 0
local targetSpeed = 0

local function detectDrift()
	local vehicle = localPlayer.vehicle
	if vehicle.velocity.length < MIN_DRIFT_SPEED then
		return 0, false
	end

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.deg(math.atan2(det, dot))
	angle = math.abs(angle)
	if angle > MIN_DRIFT_ANGLE and angle < 120 then
		return angle, true
	else
		return angle, false
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	sound = playSound(soundPath, true)
	sound.volume = 0
	targetVolume = 0
	sound.speed = 1
	targetSpeed = 1

	--sound:setEffectEnabled( 'distortion', true )
	--sound:setEffectEnabled( 'reverb', true )
	--sound:setEffectEnabled( 'compressor', true )	
	setWorldSoundEnabled(19, 24, false)
end)

addEventHandler("onClientPreRender", root, function (dt)
	if not isElement(sound) or not localPlayer.vehicle then
		return
	end
	if not localPlayer.vehicle:isOnGround() then
		return
	end	
	dt = dt / 1000

	local driftAngle, isDrifting = detectDrift()
	local mul = (driftAngle - MIN_DRIFT_ANGLE) / (90 - MIN_DRIFT_ANGLE)
	if not isDrifting then
		mul = 0
	end
	if mul < 0 then
		mul = 0
	elseif mul > 1 then
		mul = 1
	end

	if localPlayer.vehicle.controller == localPlayer and getControlState("accelerate") and getControlState("brake_reverse") then
		local velocityMul = 0.5 + (0.5 - #localPlayer.vehicle.velocity * 20)
		if velocityMul > 0.8 then
			targetVolume = 1 * velocityMul
			targetSpeed = 1 * velocityMul
		end
	else	
		targetVolume = mul * MAX_VOLUME
		targetSpeed = 0.75 + 0.25 * mul
	end
	sound.speed = sound.speed + (targetSpeed - sound.speed) * dt * 5
	sound.volume = sound.volume + (targetVolume - sound.volume) * dt * 5
	if sound.playbackPosition > 2.1 then
		sound.playbackPosition = 0.6
	end
end)