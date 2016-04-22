Colors = {}
local currentTheme = "red"
local colorSchemeDefault = {
	white			= {255, 255, 255},
	black			= {0, 0, 0},

	gray_darker 	= {29, 29, 29},
	gray_dark 		= {42, 40, 41},
	gray 			= {54, 52, 53},
	gray_light 		= {196, 203, 209},
	gray_lighter 	= {222, 230, 233},

	default 		= {228, 228, 228},
	primary			= {212, 0, 40},
	success			= {92, 184, 92},
	info			= {91, 192, 222},
	warning			= {240, 173, 78},
	danger			= {217, 83, 79}
}
local colorScheme = {}

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

local function clampColor(color)
	if color > 255 then
		color = 255
	elseif color < 0 then
		color = 0
	end
	return color
end

local function colorMul(color, mul)
	return clampColor(color[1] * mul), clampColor(color[2] * mul), clampColor(color[3] * mul)
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

function Colors.setTheme(name)
	if type(name) ~= "string" then
		return false
	end
	local file = fileOpen("themes/" .. name .. ".json")
	local themeJSON = file:read(file.size)
	file:close()

	local theme = fromJSON(themeJSON)
	if not theme then
		return false
	end

	colorScheme = {}
	for colorName, defaultColor in pairs(colorSchemeDefault) do
		if theme[colorName] then
			colorScheme[colorName] = theme[colorName]
		else
			colorScheme[colorName] = {unpack(colorSchemeDefault[colorName])}
		end
	end
	currentTheme = name
	Render.updateTheme()
	return true
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	colorScheme = exports.dpUtils:tableCopy(colorSchemeDefault)

	Colors.setTheme("red")
end)