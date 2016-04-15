Colors = {}

local colorScheme = {
	white			= {255, 255, 255},

	gray_darker 	= {29, 29, 29},
	gray_dark 		= {42, 40, 41},
	gray 			= {54, 52, 53},
	gray_light 		= {196, 203, 209},
	gray_lighter 	= {222, 230, 233},

	default 		= {238, 238, 238},
	primary			= {212, 0, 40},
	success			= {92, 184, 92},
	info			= {91, 192, 222},
	warning			= {240, 173, 78},
	danger			= {217, 83, 79}
}

function Colors.color(name, alpha)
	if not name then
		return false
	end
	local color = colorScheme[name]
	if not color then
		return tocolor(255, 255, 255, alpha)
	end
	return tocolor(color[1], color[2], color[3], alpha)
end

local function colorMul(color, mul)
	return color[1] * mul, color[2] * mul, color[3] * mul
end

function Colors.darken(name, amount, alpha)
	local color = colorScheme[name]
	if not color then
		return tocolor(0, 0, 0, alpha)
	end
	local r, g, b = colorMul(color, 1 - amount / 100)
	return tocolor(r, g, b, alpha)
end

function Colors.lighten(name, amount, alpha)
	local color = colorScheme[name]
	if not color then
		return tocolor(255, 255, 255, alpha)
	end
	local r, g, b = colorMul(color, 1 + amount / 100)
	return tocolor(r, g, b, alpha)
end