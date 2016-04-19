DpButton = {}

local buttonColors = {
	default = "default",
	default_dark = "gray_darker",
	primary = "primary"
}

function DpButton.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Button.create(properties)
	widget.type = exports.dpUtils:defaultValue(properties.type, "default")
	local color = exports.dpUtils:defaultValue(buttonColors[widget.type], "default")
	widget.font = Fonts.default

	function widget:updateTheme()
		self.colors = {
			normal = Colors.color(color),
			hover = Colors.lighten(color, 15),
			down = Colors.darken(color, 5)
		}
	end
	widget:updateTheme()
	return widget
end