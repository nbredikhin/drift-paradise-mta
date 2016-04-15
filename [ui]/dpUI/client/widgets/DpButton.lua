DpButton = {}

function DpButton.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	properties.x = 0
	properties.y = 0
	properties.type = exports.dpUtils:defaultValue(properties.type, "default")
	local colorName = "default"
	if properties.type == "default_dark" then
		colorName = "gray_darker"
	elseif properties.type == "primary" then
		colorName = "primary"
	end

	local button = Button.create(properties)
	button.colors = {
		normal = Colors.color(colorName),
		hover = Colors.lighten(colorName, 15),
		down = Colors.darken(colorName, 15)
	}
	button.textField.font = Fonts.default
	Widget.addChild(widget, button)
	return widget
end