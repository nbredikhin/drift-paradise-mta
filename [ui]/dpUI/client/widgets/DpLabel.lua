DpLabel = {}

function DpLabel.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	
	local widget = TextField.create(properties)
	widget.font = Fonts.defaultSmall
	widget.color = Colors.color("white")
	if properties.type == "primary" then
		widget.color = Colors.color("primary")
	end
	return widget
end