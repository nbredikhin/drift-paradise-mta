ScreenView = {}
local BROWSER_TRANSPARENT = true
local BROWSER_POST_GUI = false
local MAX_TRANSORM_ANGLE = 20
local screenWidth, screenHeight = guiGetScreenSize()
local browser
local maskShader = dxCreateShader("assets/shaders/mask.fx")

local function draw()
	local mx, my = screenWidth / 2, screenHeight / 2
	if isCursorShowing() then
		mx, my = getCursorPosition()
		mx = mx * screenWidth
		my = my * screenHeight
	end
	local rotX = -(mx - screenWidth / 2) / screenWidth * MAX_TRANSORM_ANGLE
	local rotY = (my - screenHeight / 2) / screenHeight * MAX_TRANSORM_ANGLE
 	dxSetShaderTransform(maskShader, rotX, rotY, 0)
	dxSetShaderValue(maskShader, "sPicTexture", browser)
	dxDrawImage(testBorder, testBorder, screenWidth - testBorder * 2, screenHeight - testBorder * 2, maskShader)
	--dxDrawImage(0, 0, screenWidth, screenHeight, browser, 0, 0, 0, tocolor(255,255,255,255), BROWSER_POST_GUI)
end

function ScreenView.start()
	browser = Browser(screenWidth, screenHeight, true, BROWSER_TRANSPARENT)
	addEventHandler("onClientRender", root, draw)
end

function ScreenView.show(resourceName)
	browser.renderingPaused = false
	outputDebugString("ScreenView.show: " .. tostring(resourceName))
	browser:loadURL("http://mta/" .. resourceName .. "/html/index.html")
	return true
end

function ScreenView.hide()
	browser:loadURL("about:blank")
	browser.renderingPaused = true
	return true
end