Utils = {}
local screenWidth, screenHeight = guiGetScreenSize()

function Utils.screenScale(val)
	if screenWidth < 1280 then
		return val * screenWidth / 1280
	end
	return val
end

function Utils.wrapAngle(value)
	if not value then
		return 0
	end
	value = math.mod(value, 360)
	if value < 0 then
		value = value + 360
	end
	return value
end

function Utils.calculateRPM(vehicle)
	local vx, vy, vz = getElementVelocity(vehicle)
	local speed = (vx^2 + vy^2 + vz^2)^0.5 * 161

	if speed < 40 then
		return speed * 162
	elseif speed < 80 then
		return (speed - 30) * 132
	elseif speed < 120 then
		return (speed - 65) * 118
	elseif speed < 160 then
		return (speed - 110) * 125
	elseif speed < 200 then
		return (speed - 130) * 92
	elseif speed >= 200 then
		if speed > 250 then
			return 6000
		else
			return (speed - 130) * 50
		end
	end
end