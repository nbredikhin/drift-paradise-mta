Render = {}
Render.resources = {}
Render.clickedWidget = false
Render.mouseClick = false
local oldMouseState = false

local function draw()
	-- Сброс цвета
	Drawing.setColor()
	-- Сброс системы координат
	Drawing.origin()

	local mouseX, mouseY = getMousePosition()
	Render.clickedWidget = false
	-- Проверка нажатия мыши
	local newMouseState = getKeyState("mouse1")
	if not Render.mouseClick and newMouseState and not oldMouseState then
		Render.mouseClick = true
	end
	oldMouseState = newMouseState

	for resourceRoot, resourceInfo in pairs(Render.resources) do
		Widget.draw(resourceInfo.rootWidget, mouseX, mouseY)
	end
	if Render.clickedWidget then
		triggerEvent("dpUI.click", Render.clickedWidget.resourceRoot, Render.clickedWidget.id)
		if type(Render.clickedWidget.click) == "function" then
			Render.clickedWidget:click(mouseX, mouseY)
		end
	end
	if Render.mouseClick then
		triggerEvent("_dpUI.clickInternal", resourceRoot)
	end
	Render.mouseClick = false
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
	widget.resourceRoot = resourceRoot
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