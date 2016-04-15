DpPanel = {}

function DpPanel.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	properties.type = exports.dpUtils:defaultValue(properties.type, "light")
	properties.x = 0
	properties.y = 0
	local rectangle = Rectangle.create(properties)
	Widget.addChild(widget, rectangle)	
	if properties.type == "dark" then
		rectangle.color = Colors.color("gray_dark")
	else
		rectangle.color = Colors.color("gray_lighter")
	end	
	return widget
end