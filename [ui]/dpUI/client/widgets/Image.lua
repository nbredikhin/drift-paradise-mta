Image = {}

function Image.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	widget.texture = properties.texture
	function widget:draw()
		if self.texture then
			Drawing.image(self.x, self.y, self.width, self.height, self.texture)
		end
	end
	return widget
end