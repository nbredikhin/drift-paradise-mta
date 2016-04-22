DpLabel = {}

function DpLabel.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	
	local widget = TextField.create(properties)
	widget.font = Fonts.defaultSmall
	widget.color = properties.color or Colors.color("white")
	if properties.fontType and Fonts[properties.fontType] then
		widget.font = Fonts[properties.fontType]
	end
	function widget:updateTheme()
		if properties.type == "primary" then
			self.color = Colors.color("primary")
		elseif properties.type == "dark" then
			self.color = Colors.color("gray_darker")
		end
	end
	widget:updateTheme()
	return widget
end