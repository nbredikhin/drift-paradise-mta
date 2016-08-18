--- Панель
-- @module dpUI.DpPanel

DpPanel = {}

local panelColors = {
	light = "gray_lighter",
	dark = "gray_dark",
	transparent = "transparent"
}

function DpPanel.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	
	local widget = Rectangle.create(properties)
	if properties.color == "transparent" then
		widget.color = tocolor(0, 0, 0, 0)
	else
		widget.color = Colors.color(panelColors[exports.dpUtils:defaultValue(properties.type, "light")])
	end
	return widget
end