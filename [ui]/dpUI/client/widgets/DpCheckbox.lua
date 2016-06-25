DpCheckbox = {}

function DpCheckbox.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	widget._type = "Checkbox"
	widget.state = false
	widget.colors = {
		normal = tocolor(0, 0, 0),
		hover = tocolor(150, 150, 150),
	}
	function widget:updateTheme()
		self.colors = {
			normal = Colors.color("primary"),
			hover = Colors.darken("primary", 15),
		}
	end
	local borderSize = 2
	local boxOffset = 5
	widget:updateTheme()

	function widget:draw()
		if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) then
			self.color = self.colors.hover
		else
			self.color = self.colors.normal
		end
		Drawing.setColor(Colors.color("gray_dark"))
		Drawing.line(self.x - 1, self.y, self.x + self.width + 1, self.y, borderSize)
		Drawing.line(self.x + self.width, self.y - 1, self.x + self.width, self.y + self.height + 1, borderSize)
		Drawing.line(self.x + self.width + 1, self.y + self.height, self.x - 1, self.y + self.height, borderSize)
		Drawing.line(self.x, self.y + self.height, self.x, self.y, borderSize)
		if self.state then
			Drawing.setColor(self.color)
			Drawing.rectangle(self.x + boxOffset, self.y + boxOffset, self.width - boxOffset * 2, self.height - boxOffset * 2)
		end
		--Drawing.setColor(self.textColor)
	end
	return widget
end

addEvent("_dpUI.clickInternal", false)
addEventHandler("_dpUI.clickInternal", resourceRoot, function ()
	if Render.clickedWidget and Render.clickedWidget._type == "Checkbox" then
 		Render.clickedWidget.state = not Render.clickedWidget.state
 	end
end)