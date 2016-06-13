--- Список
-- @module dpUI.DpList

DpList = {}

local ITEM_HEIGHT = 45

function DpList.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Widget.create(properties)
	widget.text = exports.dpUtils:defaultValue(properties.text, "")
	widget.alignX = exports.dpUtils:defaultValue(properties.alignX, "center")
	widget.alignY = exports.dpUtils:defaultValue(properties.alignY, "center")
	widget.items = exports.dpUtils:defaultValue(properties.items, {})
	widget.columns = exports.dpUtils:defaultValue(properties.columns, {})
	widget.activeItem = 1
	
	if not properties.colors then
		properties.colors = {}
	end
	widget.colors = {
		normal = properties.colors.normal or tocolor(0, 0, 0),
		hover = properties.colors.hover or tocolor(150, 150, 150),
		down = properties.colors.down or tocolor(255, 255, 255),
	}
	local textColor = "gray_dark"
	local textColorHover = "white"
	widget.font = Fonts.listItemText

	local backgroundColor1 = Colors.color("white")
	local backgroundColor2 = Colors.color("gray_lighter")
	local backgroundColorHover = Colors.color("primary")

	function widget:draw()
		-- if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) then
		-- 	if getKeyState("mouse1") then
		-- 		self.color = self.colors.down
		-- 	else
		-- 		self.color = self.colors.hover
		-- 	end
		-- else
		-- 	self.color = self.colors.normal
		-- end
		local y = self.y
		for i, item in ipairs(self.items) do
			local isHover = isPointInRect(self.mouseX, self.mouseY, 0, y, self.width, ITEM_HEIGHT)
			-- Фон
			if isHover then
				self.activeItem = i
				Drawing.setColor(backgroundColorHover)
			else
				if i % 2 == 0 then
					Drawing.setColor(backgroundColor1)
				else
					Drawing.setColor(backgroundColor2)
				end
			end
			Drawing.rectangle(self.x, y, self.width, ITEM_HEIGHT)

			-- Столбцы
			local x = self.x
			for j, column in ipairs(self.columns) do
				local columnText = tostring(item[j])
				local align = column.align or "center"
				local columnWidth = column.size * self.width
				if column.color and not isHover then
					Drawing.setColor(Colors.color(column.color))
				else
					local alpha = 255
					if column.alpha then
						local a = column.alpha
						if isHover then
							a = 1 - a
						end
						alpha = alpha * a
					end
					if isHover then
						Drawing.setColor(Colors.color(textColorHover, alpha))
					else
						Drawing.setColor(Colors.color(textColor, alpha))
					end
					
				end
				local drawX = x
				if column.offset then
					drawX = drawX + self.width * column.offset
				end
				Drawing.text(drawX, y, columnWidth, ITEM_HEIGHT, columnText, align, "center", true, false)
				x = x + columnWidth
			end

			y = y + ITEM_HEIGHT
		end
	end
	return widget
end