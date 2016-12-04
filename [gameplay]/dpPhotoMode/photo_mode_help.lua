PhotoModeHelp = {}

local helpLines = {
	nil,
	{keys = {"Q", "E"}, 														locale = "photo_mode_help_roll"},
	{keys = {"W", "A", "S", "D"}, 												locale = "photo_mode_help_move"},
	{keys = {"Alt", "Shift"}, 													locale = "photo_mode_help_speed"},
	{keys = {"controls_mouse"}, 												locale = "photo_mode_help_look"},
	{keys = {"controls_mouse_wheel"}, 											locale = "photo_mode_help_zoom"},
	{keys = {"controls_space", "Ctrl"}, 										locale = "photo_mode_help_updown"},
	{keys = {CONTROLS.TOGGLE_SMOOTH:upper()}, 									locale = "photo_mode_help_smooth"},
	{keys = {CONTROLS.NEXT_TIME:upper(), CONTROLS.PREVIOUS_TIME:upper()},		locale = "photo_mode_help_time"},
	{keys = {CONTROLS.NEXT_WEATHER:upper(), CONTROLS.PREVIOUS_WEATHER:upper()},	locale = "photo_mode_help_weather"},
	{keys = {"I"},																locale = "photo_mode_help_tips"},
	{keys = {PHOTO_MODE_KEY},													locale = "photo_mode_help_exit"}
}

local weatherLine = ""

local LINE_HEIGHT = 25
local LINE_OFFSET = 3
local HORIZONTAL_OFFSET = 2
local EDGE_OFFSET = 10

local screenSize = Vector2(guiGetScreenSize())
local font
local themeColor = {}
local targetAlpha = 0
local alpha = targetAlpha

function PhotoModeHelp.start()
	font = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)
	targetAlpha = 230
	alpha = 0

	-- Add screenshot keys to help
	local screenshotBoundKeys = getBoundKeys("screenshot")
	if screenshotBoundKeys then
		local screenshotKeys = {}
		for key, state in pairs(screenshotBoundKeys) do
			table.insert(screenshotKeys, key)
		end

		if #screenshotKeys > 0 then
			helpLines[1] = {keys = screenshotKeys, locale = "photo_mode_help_shoot"}
		end
	end

	-- Get localized description
	for i, line in ipairs(helpLines) do
		for j, key in ipairs(line.keys) do
			helpLines[i].keys[j] = exports.dpLang:getString(key)
		end
		line.text = exports.dpLang:getString(line.locale)
	end
end

function PhotoModeHelp.stop()
	if isElement(font) then
		destroyElement(font)
	end
end

local function drawHelp()
	local y = EDGE_OFFSET

	for i, line in ipairs(helpLines) do
		local x = EDGE_OFFSET

		for j, key in ipairs(line.keys) do
			local keyWidth = dxGetTextWidth(key, 1, font) + 10

			dxDrawRectangle(x, y, keyWidth, LINE_HEIGHT, tocolor(themeColor.r, themeColor.g, themeColor.b, alpha))
			dxDrawText(key, x, y, x + keyWidth, y + LINE_HEIGHT, tocolor(255, 255, 255, alpha), 1, font, "center", "center")

			x = x + keyWidth + HORIZONTAL_OFFSET
		end

		local textWidth = dxGetTextWidth(line.text, 1, font) + 10

		dxDrawRectangle(x, y, textWidth, LINE_HEIGHT, tocolor(42, 40, 42, alpha))
		dxDrawText(line.text, x, y, x + textWidth, y + LINE_HEIGHT, tocolor(255, 255, 255, alpha), 1, font, "center", "center")

		y = y + LINE_HEIGHT + LINE_OFFSET
	end
end

local function drawParams()
	local parameters = {
		{
			name = "photo_mode_param_time", value = ("%02d:%02d"):format(getTime())
		},
		{
			name = "photo_mode_param_weather",
			lvalue = (currentWeather == 0) and "photo_mode_param_weather_unknown" or weatherList[currentWeather].name
		}
	}

	local y = screenSize.y - 10 - ((LINE_HEIGHT + LINE_OFFSET) * #parameters)

	for i, param in pairs(parameters) do
		local x = EDGE_OFFSET

		local name = exports.dpLang:getString(param.name)
		local nameWidth = dxGetTextWidth(name, 1, font) + 10

		dxDrawRectangle(x, y, nameWidth, LINE_HEIGHT, tocolor(themeColor.r, themeColor.g, themeColor.b, alpha))
		dxDrawText(name, x, y, x + nameWidth, y + LINE_HEIGHT, tocolor(255, 255, 255, alpha), 1, font, "center", "center")

		x = x + nameWidth + HORIZONTAL_OFFSET

		local value
		if param.lvalue then
			value = exports.dpLang:getString(param.lvalue)
		else
			value = param.value
		end
		local valueWidth = dxGetTextWidth(value, 1, font) + 10

		dxDrawRectangle(x, y, valueWidth, LINE_HEIGHT, tocolor(42, 40, 42, alpha))
		dxDrawText(value, x, y, x + valueWidth, y + LINE_HEIGHT, tocolor(255, 255, 255, alpha), 1, font, "center", "center")

		y = y + LINE_HEIGHT + LINE_OFFSET
	end
end

function PhotoModeHelp.draw()
	alpha = alpha + (targetAlpha - alpha) * 0.1
	themeColor.r, themeColor.g, themeColor.b = exports.dpUI:getThemeColor()

	drawHelp()
	drawParams()
end
