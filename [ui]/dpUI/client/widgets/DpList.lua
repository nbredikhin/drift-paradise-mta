function DpList.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	
	local widget = Widget.create(properties)
	widget.text = exports.dpUtils:defaultValue(properties.text, "")
	widget.alignX = exports.dpUtils:defaultValue(properties.alignX, "center")
	widget.alignY = exports.dpUtils:defaultValue(properties.alignY, "center")
	if not properties.colors then
		properties.colors = {}
	end
	widget.colors = {
		normal = properties.colors.normal or tocolor(0, 0, 0),
		hover = properties.colors.hover or tocolor(150, 150, 150),
		down = properties.colors.down or tocolor(255, 255, 255),
	}
	widget.textColor = Colors.color("white")

	function widget:draw()
		if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) then
			if getKeyState("mouse1") then
				self.color = self.colors.down
			else
				self.color = self.colors.hover
			end
		else
			self.color = self.colors.normal
		end
		
		Drawing.rectangle(self.x, self.y, self.width, self.height)
		Drawing.setColor(self.textColor)
		Drawing.text(self.x, self.y, self.width, self.height, self.text, self.alignX, self.alignY, true, false)		
	end
	return widget
end