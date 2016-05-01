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
