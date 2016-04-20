Video = {}
Video.active = false
local screenWidth, screenHeight = guiGetScreenSize()
local browser
local videoQuality = 0.5
local isBrowserVisible = false
local skipTextAlpha = 0
local isSkipTextVisible = false

local function draw()
	if isBrowserVisible then
		dxDrawImage(0, 0, screenWidth, screenHeight, browser)
	else
		dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0))
	end

	if isSkipTextVisible then
		skipTextAlpha = math.min(1, skipTextAlpha + 0.01) 
		dxDrawText("Нажмите ПРОБЕЛ, чтобы пропустить видео", 0, screenHeight * 0.8, screenWidth, screenHeight, tocolor(255, 255, 255, 255 * skipTextAlpha), 2, "default", "center", "center")
	end

	if getKeyState("space") then
		Video.stop()
	end
end

local function setupBrowser()
	loadBrowserURL(browser, "https://www.youtube.com/embed/e1cHm9NjIe0?autoplay=1")
	setTimer(function ()
		isBrowserVisible = true
		setTimer(function ()
			isSkipTextVisible = true
		end, 5000, 1)
	end, 5000, 1)
end

function Video.start()
	if Video.active then
		return false
	end
	Video.active = true
	isBrowserVisible = false
	isSkipTextVisible = false
	skipTextAlpha = 0
	browser = Browser(screenWidth * videoQuality, screenHeight * videoQuality, false, false)
	addEventHandler("onClientBrowserCreated", browser, setupBrowser)
	addEventHandler("onClientRender", root, draw)
	return true
end

function Video.stop()
	if not Video.active then
		return false
	end
	Video.active = false
	destroyElement(browser)
	browser = nil
	removeEventHandler("onClientRender", root, draw)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Video.start()
end)