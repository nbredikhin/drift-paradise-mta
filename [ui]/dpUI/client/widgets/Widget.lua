Widget = {}

function Widget.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = {}
	widget.x = properties.x or 0
	widget.y = properties.y or 0
	widget.width = properties.width or 0
	widget.height = properties.height or 0
	widget.parent = nil
	widget.children = {}
	widget.color = properties.color or Colors.color("white")
	return widget
end

function Widget.draw(widget, mouseX, mouseY)
	mouseX = mouseX - widget.x
	mouseY = mouseY - widget.y
	if widget.draw then
		widget.mouseX = mouseX
		widget.mouseY = mouseY		
		Drawing.setColor(widget.color)
		widget:draw()
	end
	Drawing.translate(widget.x, widget.y)
	for i, child in ipairs(widget.children) do
		Widget.draw(child, mouseX, mouseY)
	end
	Drawing.translate(-widget.x, -widget.y)
end

function Widget.getChildIndex(widget, child)
	if not widget or not child then
		return false
	end
	for i, c in ipairs(widget.children) do
		if c == child then
			return i
		end
	end
	return false
end

function Widget.addChild(widget, child)
	if not widget or not child then
		return false
	end
	if Widget.getChildIndex(widget, child) then
		return false
	end
	table.insert(widget.children, child)
	child.parent = widget
	return true
end

function Widget.removeChild(widget, child)
	if not widget or not child then
		return false
	end
	local index = Widget.getChildIndex(widget, child)
	if not index then
		return false
	end
	table.remove(widget.children, index)
	child.parent = nil
	return true
end