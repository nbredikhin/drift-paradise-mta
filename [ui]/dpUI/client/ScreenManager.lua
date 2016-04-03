ScreenManager = {}
local screenWidth, screenHeight = guiGetScreenSize()

local BROWSER_TRANSPARENT = true
local BROWSER_POST_GUI = false
local BROWSER_MOUSE_WHEEL_SPEED = 40
local MAX_TRANSORM_ANGLE = 10

-- Браузер и шейдер
local isActive = false
local maskShader

local isBackgroundVisible = false
local activeScreen

local testTexture = dxCreateTexture("assets/images/tab.png")
local ANIMATION_SPEED = 0.05
local animationProgress = 0

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
	animationProgress = math.min(1, animationProgress + ANIMATION_SPEED)

	local mouseX, mouseY = getMousePosition()
	local rotationX = -(mouseX - screenWidth / 2) / screenWidth * MAX_TRANSORM_ANGLE
	local rotationY = (mouseY - screenHeight / 2) / screenHeight * MAX_TRANSORM_ANGLE

 	dxSetShaderTransform(maskShader, rotationX, rotationY, 0)
	dxSetShaderValue(maskShader, "sPicTexture", ScreenManager.browser)

	-- Фон
	if isBackgroundVisible then
		dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 200 * animationProgress))
	end
	if maskShader then
		-- Браузер
		dxDrawImage(
			0, 
			0, 
			screenWidth, 
			screenHeight, 
			maskShader, 
			0, 0, 0, 
			tocolor(255, 255, 255, 255 * animationProgress), 
			BROWSER_POST_GUI
		)
	else
		dxDrawImage(0, 0, screenWidth, screenHeight, ScreenManager.browser, 0, 0, 0, tocolor(255, 255, 255, 255 * animationProgress), BROWSER_POST_GUI)
	end
end

function ScreenManager.start()
	ScreenManager.browser = Browser(screenWidth, screenHeight, true, BROWSER_TRANSPARENT)
	maskShader = exports.dpAssets:createShader("texture3d.fx")
	
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientBrowserCreated", ScreenManager.browser, function ()
		ScreenRender.start()
		ScreenManager.hide()
	end)
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

function ScreenManager.show(name, options)
	if not name then
		return false
	end
	if not options then
		options = {}
	end
	if options.animation then
		animationProgress = 0
	else
		animationProgress = 1
	end
	isBackgroundVisible = not not options.background
	ScreenRender.renderScreen(name)
	isActive = true
	activeScreen = name
	outputDebugString("ScreenManager.show: " .. tostring(name))
	return true
end

function ScreenManager.hide()
	ScreenRender.clear()
	isActive = false
	return true
end