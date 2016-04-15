DpInput = {}

function DpInput.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	properties.x = 0
	properties.y = 0
	properties.type = exports.dpUtils:defaultValue(properties.type, "dark")
	local colorName = "gray"
	if properties.type == "light" then
		colorName = "gray_light"
	end

	local button = Button.create(properties)
	button.colors = {
		normal = Colors.color(colorName),
		hover = Colors.lighten(colorName, 15),
		down = Colors.darken(colorName, 15)
	}
	button.textField.font = Fonts.light
	button.textField.alignX = "left"
	button.textField.x = 10
	button.textField.color = Colors.lighten(colorName, 100)
	Widget.addChild(widget, button)
	return widget
end