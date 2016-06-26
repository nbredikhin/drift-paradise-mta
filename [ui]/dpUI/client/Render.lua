Render = {}
Render.resources = {}
Render.clickedWidget = false
Render.mouseClick = false

local MAX_TRANSORM_ANGLE = 20
local screenWidth, screenHeight = guiGetScreenSize()
local screenWidthLimited, screenHeightLimited = getLimitedScreenSize()
local oldMouseState = false
local renderTarget3D

local targetFadeVal = 0
local currentFadeVal = 0
local fadeSpeed = 10
local fadeActive = false

local forceRotationX, forceRotationY = 0, 0

-- Размытие экрана при затемнении
local BLUR_ENABLED = true
local BLUR_INTERNSIVITY = 3
local blurBox

-- Отрисовка в 3D
local function draw()
	dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 200 * currentFadeVal))
	-- Сброс цвета
	Drawing.setColor()
	-- Сброс системы координат
	Drawing.origin()

	local mouseX, mouseY = getMousePosition()
	if MessageBox.isActive() then
		mouseX = 0
		mouseY = 0
	end
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

	if Render.mouseClick and not MessageBox.isActive() then
		triggerEvent("_dpUI.clickInternal", resourceRoot)
	end
	if Render.clickedWidget and not MessageBox.isActive() then
		triggerEvent("dpUI.click", Render.clickedWidget.resourceRoot, Render.clickedWidget.id)
		if type(Render.clickedWidget.click) == "function" then
			Render.clickedWidget:click(mouseX, mouseY)
		end
	end
	Render.mouseClick = false

	-- Draw renderTarget3D
	if renderTarget3D then
		RenderTarget3D.draw(renderTarget3D, 0, 0, screenWidth, screenHeight)

		local mouseX, mouseY = getMousePosition()
		if not isCursorShowing() then
			mouseX, mouseY = forceRotationX * screenWidth, forceRotationY * screenHeight
		end
		local rotationX = -(mouseX - screenWidth / 2) / screenWidth * MAX_TRANSORM_ANGLE
		local rotationY = (mouseY - screenHeight / 2) / screenHeight * MAX_TRANSORM_ANGLE

		RenderTarget3D.setTransform(renderTarget3D, rotationX, rotationY, 0)
	end
end

local function update(dt)
	dt = dt / 1000
	currentFadeVal = currentFadeVal + (targetFadeVal - currentFadeVal) * fadeSpeed * dt

	if blurBox then
		exports.blur_box:setBlurBoxColor( blurBox, 255, 255, 255, 255 * currentFadeVal)
	end
end

function Render.start()
	renderTarget3D = RenderTarget3D.create(screenWidthLimited, screenHeightLimited)
	Drawing.POST_GUI = not not renderTarget3D.fallback
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)

	BLUR_ENABLED = exports.dpConfig:getProperty("ui.blur")
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

function Render.updateWidgetLocale(widget)
	if widget.locale then
		if widget.placeholder then
			widget.placeholder = exports.dpLang:getString(widget.locale)
		elseif widget.text then
			widget.text = exports.dpLang:getString(widget.locale)
		end
	end
end

function Render.exportWidget(widget, resourceRoot)
	Render.setupResource(resourceRoot)
	table.insert(Render.resources[resourceRoot].widgets, widget)
	widget.id = #Render.resources[resourceRoot].widgets
	widget.resourceRoot = resourceRoot

	-- Локализация
	Render.updateWidgetLocale(widget)
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

addEvent("dpLang.languageChanged", false)
addEventHandler("dpLang.languageChanged", root, function (newLanguage)
	for resourceRoot, resourceInfo in pairs(Render.resources) do
		for i, widget in ipairs(resourceInfo.widgets) do
			Render.updateWidgetLocale(widget)
		end
	end
end)

function Render.updateTheme()
	for resourceRoot, resourceInfo in pairs(Render.resources) do
		for i, widget in ipairs(resourceInfo.widgets) do
			if type(widget.updateTheme) == "function" then
				widget:updateTheme()
			end
		end
	end
end

function Render.getRenderTarget()
	return renderTarget3D.renderTarget
end

local function setupBlurBox()
	blurBox = exports.blur_box:createBlurBox(0, 0, screenWidth, screenHeight, 255, 255, 255, 0, false)
	if blurBox then
		exports.blur_box:setScreenResolutionMultiplier(0.4, 0.4)
		exports.blur_box:setBlurIntensity(BLUR_INTERNSIVITY)
	end
end

function Render.fadeScreen(fade)
	fade = not not fade
	if fade == fadeActive then
		return
	end
	fadeActive = fade
	if fade then
		targetFadeVal = 1
		if BLUR_ENABLED then
			setupBlurBox()
		end
	else
		targetFadeVal = 0

		if blurBox then
			exports.blur_box:destroyBlurBox(blurBox)
			blurBox = nil
		end
	end
end

function Render.forceRotation(x, y)
	if type(x) == "number" and type(y) == "number" then
		forceRotationX = x
		forceRotationY = y
	end
end

addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if key == "ui.blur" then
		value = not not value
		if BLUR_ENABLED ~= value then
			if fadeActive then
				if value then
					setupBlurBox()
				else
					if blurBox then
						exports.blur_box:destroyBlurBox(blurBox)
						blurBox = nil
					end
				end
			end
			BLUR_ENABLED = value
		end
	end
end)