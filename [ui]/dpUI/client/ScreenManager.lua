ScreenManager = {}
local screenWidth, screenHeight = guiGetScreenSize()

local BROWSER_TRANSPARENT = true
local BROWSER_POST_GUI = false
local BROWSER_MOUSE_WHEEL_SPEED = 40
local MAX_TRANSORM_ANGLE = 10

-- Браузер и шейдер
local isActive = false
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
	dxSetShaderValue(maskShader, "sPicTexture", ScreenManager.browser)

	-- Фон
	dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 200))
	if maskShader then
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
	else
		dxDrawImage(0, 0, screenWidth, screenHeight, ScreenManager.browser, 0, 0, 0, tocolor(255, 255, 255, 255), BROWSER_POST_GUI)
	end
end

function ScreenManager.start()
	ScreenManager.browser = Browser(screenWidth, screenHeight, true, BROWSER_TRANSPARENT)
	maskShader = dxCreateShader("assets/shaders/mask.fx")

	addEventHandler("onClientRender", root, draw)
	ScreenRender.start()
	ScreenManager.hide()

	addEventHandler("onClientCursorMove", root, function (_, _, x, y)
		ScreenManager.browser:injectMouseMove(x, y)
	end)
	addEventHandler("onClientClick", root, function (button, state)
		if state == "down" then
			ScreenManager.browser:injectMouseDown(button)
		else
			ScreenManager.browser:injectMouseUp(button)
		end
	end)
	addEventHandler("onClientKey", root, function (button)
		local wheelOffset = 0
		if button == "mouse_wheel_down" then
			ScreenManager.browser:injectMouseWheel(-BROWSER_MOUSE_WHEEL_SPEED, 0)
		elseif button == "mouse_wheel_up" then
			ScreenManager.browser:injectMouseWheel(BROWSER_MOUSE_WHEEL_SPEED, 0)
		end
	end)	
end

function ScreenManager.show(name)
	if not name then
		return false
	end
	ScreenManager.browser.renderingPaused = false
	ScreenRender.renderScreen(name)
	outputDebugString("ScreenManager.show: " .. tostring(name))
	isActive = true
	return true
end

function ScreenManager.hide()
	ScreenManager.browser.renderingPaused = true
	isActive = false
	return true
end