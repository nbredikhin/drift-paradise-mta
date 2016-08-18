Widget = {}

function Widget.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = {}
	widget.x = exports.dpUtils:defaultValue(properties.x, 0)
	widget.y = exports.dpUtils:defaultValue(properties.y, 0)
	widget.width = exports.dpUtils:defaultValue(properties.width, 0)
	widget.height = exports.dpUtils:defaultValue(properties.height, 0)
	widget.parent = nil
	widget.children = {}
	widget.color = exports.dpUtils:defaultValue(properties.color, Colors.color("white"))
	widget.visible = exports.dpUtils:defaultValue(properties.visible, true)
	widget.text = exports.dpUtils:defaultValue(properties.text, "")
	widget.locale = exports.dpUtils:defaultValue(properties.locale, false)
	return widget
end

function Widget.draw(widget, mouseX, mouseY)
	if not widget then
		return
	end
	if not widget.visible then
		return
	end
	mouseX = mouseX - widget.x
	mouseY = mouseY - widget.y
	widget.mouseX = mouseX
	widget.mouseY = mouseY	
	if isPointInRect(mouseX, mouseY, 0, 0, widget.width, widget.height) then
		widget.mouseHover = true
		if Render.mouseClick then
			Render.clickedWidget = widget
		end
	else
		widget.mouseHover = false
	end
	if widget.draw then		
		Drawing.setColor(widget.color)
		Drawing.setFont(widget.font)
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
	if child.parent then
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