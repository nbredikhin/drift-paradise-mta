DpInput = {}

local inputColors = {
	dark = "gray",
	light = "gray_light"
}

function DpInput.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Input.create(properties)
	local colorName = inputColors[exports.dpUtils:defaultValue(properties.type, "dark")]
	function widget:updateTheme()
		self.colors = {
			normal = Colors.color(colorName),
			hover = Colors.lighten(colorName, 15),
			active = Colors.lighten(colorName, 20)
		}
	end
	widget:updateTheme()
	return widget
end