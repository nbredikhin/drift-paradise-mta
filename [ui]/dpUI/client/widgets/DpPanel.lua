DpPanel = {}

local panelColors = {
	light = "gray_lighter",
	dark = "gray_dark"
}

function DpPanel.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	
	local widget = Rectangle.create(properties)
	widget.color = Colors.color(panelColors[exports.dpUtils:defaultValue(properties.type, "light")])
	return widget
end