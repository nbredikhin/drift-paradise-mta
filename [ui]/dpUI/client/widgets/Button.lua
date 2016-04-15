Button = {}

function Button.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	local widget = Widget.create(properties)
	properties = exports.dpUtils:tableCopy(properties)

	properties.x = 0
	properties.y = 0
	-- Фон
	widget.background = Rectangle.create(properties)
	widget.background.color = exports.dpUtils:defaultValue(properties.backgroundColor, tocolor(0, 0, 0))
	Widget.addChild(widget, widget.background)
	-- Текст
	properties.alignX = "center"
	properties.alignY = "center"
	widget.textField = TextField.create(properties)
	Widget.addChild(widget, widget.textField)

	if not properties.colors then
		properties.colors = {}
	end
	widget.colors = {
		normal = widget.background.color,
		hover = properties.colors.hover or tocolor(150, 150, 150),
		down = properties.colors.down or tocolor(255, 255, 255),
	}

	function widget:draw()
		if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) then
			if getKeyState("mouse1") then
				self.background.color = self.colors.down
			else
				self.background.color = self.colors.hover
			end
		else
			self.background.color = self.colors.normal
		end
	end
	return widget
end