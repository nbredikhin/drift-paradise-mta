function wrapAngle(value)
	if not value then
		return 0
	end
	value = math.mod(value, 360)
	if value < 0 then
		value = value + 360
	end
	return value
end

function wrapAngleRadians(value)
	if not value then
		return 0
	end
	local pi2 = math.pi * 2
	value = math.mod(value, pi2)
	if value < 0 then
		value = value + pi2
	end
	return value
end

function differenceBetweenAngles(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	if difference > 180 then
		difference = difference - 360
	elseif difference < -180 then
		difference = difference + 360
	end
	return difference
end

function differenceBetweenAnglesRadians(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	if difference > math.pi then
		difference = difference - math.pi * 2
	elseif difference < -math.pi then
		difference = difference + math.pi * 2
	end
	return difference
end
