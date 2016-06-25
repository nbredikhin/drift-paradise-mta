PhotoModeHelp = {}
local helpLines = {
	{keys = {"Q", "E"}, 				text = "", locale = "photo_mode_help_roll"},
	{keys = {"W", "A", "S", "D"}, 		text = "", locale = "photo_mode_help_move"},
	{keys = {"Alt", "Shift"}, 			text = "", locale = "photo_mode_help_speed"},
	{keys = {"controls_mouse"}, 		text = "", locale = "photo_mode_help_look"},
	{keys = {"Z", "X"}, 				text = "", locale = "photo_mode_help_zoom"},
	{keys = {"controls_space", "Ctrl"}, text = "", locale = "photo_mode_help_updown"},
	{keys = {"C"}, 						text = "", locale = "photo_mode_help_smooth"},
	{keys = {"I"},						text = "", locale = "photo_mode_help_tips"}
}
local lineHeight = 25
local font
local targetAlpha = 0
local alpha = targetAlpha

function PhotoModeHelp.start()
	font = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)
	targetAlpha = 230
	alpha = 0

	for i, line in ipairs(helpLines) do
		for j, key in ipairs(line.keys) do
			helpLines[i].keys[j] = exports.dpLang:getString(key)
		end
		helpLines[i].text = exports.dpLang:getString(line.locale)
	end
end

function PhotoModeHelp.stop()
	if isElement(font) then
		destroyElement(font)
	end
end

function PhotoModeHelp.draw()
	alpha = alpha + (targetAlpha - alpha) * 0.1
	local y = 10
	local x = 10
	local r, g, b = exports.dpUI:getThemeColor()
	for i, line in ipairs(helpLines) do
		local cx = x
		for j, key in ipairs(line.keys) do
			local keyWidth = dxGetTextWidth(key, 1, font) + 10
			dxDrawRectangle(cx, y, keyWidth, lineHeight, tocolor(r, g, b, alpha))
			dxDrawText(key, cx, y, cx + keyWidth, y + lineHeight, tocolor(255, 255, 255, alpha), 1, font, "center", "center")
			cx = cx + keyWidth + 2
		end
		local textWidth = dxGetTextWidth(line.text, 1, font) + 10
		dxDrawRectangle(cx, y, textWidth, lineHeight, tocolor(42, 40, 42, alpha))
		dxDrawText(line.text, cx, y, cx + textWidth, y + lineHeight, tocolor(255, 255, 255, alpha), 1, font, "center", "center")
		y = y + lineHeight + 3
	end
end

-- PhotoModeHelp.start()
-- addEventHandler("onClientRender", root, PhotoModeHelp.draw)