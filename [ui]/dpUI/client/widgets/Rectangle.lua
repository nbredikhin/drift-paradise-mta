Rectangle = {}

function Rectangle.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)

	function widget:draw()
		Drawing.rectangle(self.x, self.y, self.width, self.height)
	end
	return widget
end