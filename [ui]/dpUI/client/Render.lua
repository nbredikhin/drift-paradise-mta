Render = {}
Render.resources = {}

local function draw()
	-- Сброс цвета
	Drawing.setColor()
	-- Сброс системы координат
	Drawing.origin()

	local mouseX, mouseY = getMousePosition()
	for resourceRoot, resourceInfo in pairs(Render.resources) do
		Widget.draw(resourceInfo.rootWidget, mouseX, mouseY)
	end
end

function Render.start()
	addEventHandler("onClientRender", root, draw)
end

function Render.setupResource(resourceRoot)
	if Render.resources[resourceRoot] then
		return false
	end
	Render.resources[resourceRoot] = {
		widgets = {},
		rootWidget = Widget.create()
	}
	table.insert(Render.resources[resourceRoot].widgets, Render.resources[resourceRoot].rootWidget)
	Render.resources[resourceRoot].rootWidget.id = 1
end

function Render.exportWidget(widget, resourceRoot)
	Render.setupResource(resourceRoot)
	table.insert(Render.resources[resourceRoot].widgets, widget)
	widget.id = #Render.resources[resourceRoot].widgets
	return widget.id
end

function Render.getWidgetById(resourceRoot, id)
	if not resourceRoot or not id then
		return false
	end
	if not Render.resources[resourceRoot] then
		return false
	end
	return Render.resources[resourceRoot].widgets[id]
end

addEventHandler("onClientResourceStop", root, function ()
	Render.resources[source] = nil
end)