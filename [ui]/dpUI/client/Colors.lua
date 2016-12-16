Colors = {}

local THEME_NAMES = {"purple", "blue", "red", "orange", "green"}
local DEFAULT_THEME_NAME = "red"
local DEFAULT_THEME = {
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

local currentThemeName
local themes = {}

function Colors.color(name, alpha)
	if not name then
		return false
	end
	local color = themes[currentThemeName][name]
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
	local color = themes[currentThemeName][name]
	if not color then
		return tocolor(0, 0, 0, alpha)
	end
	local r, g, b = colorMul(color, 1 - amount / 100)
	return tocolor(r, g, b, alpha)
end

function Colors.lighten(name, amount, alpha)
	local color = themes[currentThemeName][name]
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

	local exist = false
	for themeName in pairs(themes) do
		if name == themeName then
			exist = true
			break
		end
	end
	if not exist then
		return false
	end

	currentThemeName = name
	Render.updateTheme()
	triggerEvent("dpUI.updateTheme", resourceRoot)
	return true
end

function Colors.getThemeColor(themeName)
	if type(themeName) == "string" then
		return unpack(themes[themeName]["primary"])
	end

	return unpack(themes[currentThemeName]["primary"])
end

function Colors.getThemeName()
	return currentThemeName
end

local function loadThemes()
	for i, themeName in pairs(THEME_NAMES) do
		local file = fileOpen("themes/" .. themeName .. ".json")
		if file then
			local themeJSON = file:read(file.size)
			file:close()

			local theme = fromJSON(themeJSON)
			if theme then
				themes[themeName] = {}
				for colorName, defaultColor in pairs(DEFAULT_THEME) do
					if theme[colorName] then
						themes[themeName][colorName] = theme[colorName]
					else
						themes[themeName][colorName] = {unpack(DEFAULT_THEME[colorName])}
					end
				end
			end
		end
	end

	local theme = exports.dpConfig:getProperty("ui.theme")
	if theme then
		Colors.setTheme(theme)
	else
		Colors.setTheme(DEFAULT_THEME_NAME)
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	loadThemes()
end)

addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if key == "ui.theme" then
		Colors.setTheme(value)
	end
end)
