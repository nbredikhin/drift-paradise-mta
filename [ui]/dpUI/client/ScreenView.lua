ScreenView = {}
local screenWidth, screenHeight = guiGetScreenSize()

local BROWSER_TRANSPARENT = true
local BROWSER_POST_GUI = true
local BROWSER_MOUSE_WHEEL_SPEED = 40
local MAX_TRANSORM_ANGLE = 10

-- Браузер и шейдер
local isActive = false
local browser
local maskShader

local testBorder = 0
local testTexture = dxCreateTexture("assets/images/tab.png")

local function getMousePosition()
	local mx, my = screenWidth / 2, screenHeight / 2
	if isCursorShowing() then
		mx, my = getCursorPosition()
		mx = mx * screenWidth
		my = my * screenHeight
	end
	return mx, my
end

local function draw()
	if not isActive then
		return
	end
	local mouseX, mouseY = getMousePosition()
	local rotationX = -(mouseX - screenWidth / 2) / screenWidth * MAX_TRANSORM_ANGLE
	local rotationY = (mouseY - screenHeight / 2) / screenHeight * MAX_TRANSORM_ANGLE

 	dxSetShaderTransform(maskShader, rotationX, rotationY, 0)
	dxSetShaderValue(maskShader, "sPicTexture", browser)

	-- Фон
	dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 200))
	-- Браузер
	dxDrawImage(
		testBorder, 
		testBorder, 
		screenWidth - testBorder * 2, 
		screenHeight - testBorder * 2, 
		maskShader, 
		0, 0, 0, 
		tocolor(255, 255, 255, 255), 
		BROWSER_POST_GUI
	)
	-- dxDrawImage(0, 0, screenWidth, screenHeight, browser, 0, 0, 0, tocolor(255,255,255,100), BROWSER_POST_GUI)
end

showCursor(true)
setPlayerHudComponentVisible("all", false)

function ScreenView.start()
	maskShader = dxCreateShader("assets/shaders/mask.fx")
	browser = Browser(screenWidth, screenHeight, true, BROWSER_TRANSPARENT)
	addEventHandler("onClientRender", root, draw)
	ScreenView.hide()
end

function ScreenView.show(resourceName)
	if not resourceName then
		return false
	end
	browser.renderingPaused = false
	outputDebugString("ScreenView.show: " .. tostring(resourceName))
	ScreenRender.renderScreen(browser, resourceName)
	isActive = true
	return true
end

function ScreenView.hide()
	browser:loadURL("about:blank")
	browser.renderingPaused = true
	isActive = false
	return true
end

addEventHandler("onClientCursorMove", root, function (_, _, x, y)
	browser:injectMouseMove(x, y)
end)

addEventHandler("onClientClick", root, function (button, state)
	if state == "down" then
		browser:injectMouseDown(button)
	else
		browser:injectMouseUp(button)
	end
end)

addEventHandler("onClientKey", root, function (button)
	local wheelOffset = 0
	if button == "mouse_wheel_down" then
		browser:injectMouseWheel(-BROWSER_MOUSE_WHEEL_SPEED, 0)
	elseif button == "mouse_wheel_up" then
		browser:injectMouseWheel(BROWSER_MOUSE_WHEEL_SPEED, 0)
	end
end)