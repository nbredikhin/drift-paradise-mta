Render = {}
Render.resources = {}
Render.clickedWidget = false
Render.mouseClick = false

local MAX_TRANSORM_ANGLE = 20 
local screenWidth, screenHeight = guiGetScreenSize()
local screenWidthLimited, screenHeightLimited = getLimitedScreenSize()
local oldMouseState = false

-- Отрисовка в 3D

local function draw()
	-- Сброс цвета
	Drawing.setColor()
	-- Сброс системы координат
	Drawing.origin()

	local mouseX, mouseY = getMousePosition()
	mouseX = mouseX / screenWidth * screenWidthLimited
	mouseY = mouseY / screenHeight * screenHeightLimited

	Render.clickedWidget = false
	-- Проверка нажатия мыши
	local newMouseState = getKeyState("mouse1")
	if not Render.mouseClick and newMouseState and not oldMouseState then
		Render.mouseClick = true
	end
	oldMouseState = newMouseState

	RenderTarget3D.set(renderTarget3D)
	for resourceRoot, resourceInfo in pairs(Render.resources) do
		Widget.draw(resourceInfo.rootWidget, mouseX, mouseY)
	end
	dxSetRenderTarget()

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

	-- Draw renderTarget3D
	if renderTarget3D then
		RenderTarget3D.draw(renderTarget3D, 0, 0, screenWidth, screenHeight)

		local mouseX, mouseY = getMousePosition()
		local rotationX = -(mouseX - screenWidth / 2) / screenWidth * MAX_TRANSORM_ANGLE
		local rotationY = (mouseY - screenHeight / 2) / screenHeight * MAX_TRANSORM_ANGLE	

		RenderTarget3D.setTransform(renderTarget3D, rotationX, rotationY, 0)			
	end
end

function Render.start()
	renderTarget3D = RenderTarget3D.create(screenWidthLimited, screenHeightLimited)
	outputDebugString("Created RenderTarget3D: " .. tostring(renderTarget3D))
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