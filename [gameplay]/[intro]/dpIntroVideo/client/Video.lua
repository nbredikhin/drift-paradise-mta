Video = {}
Video.active = false
local screenWidth, screenHeight = guiGetScreenSize()
local browser
local isBrowserVisible = false
local skipTextAlpha = 0
local isLogoVisible = false
local videoScale = 0.7
local logoTexture
local logoWidth, logoHeight

local function draw()
	if isBrowserVisible then
		dxDrawImage(0, 0, screenWidth, screenHeight, browser)
		if isLogoVisible then
			dxDrawImage(screenWidth / 2 - logoWidth / 2, screenHeight * 0.55 - logoHeight / 2, logoWidth, logoHeight, logoTexture)
		end
	else
		dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0))
	end

	if getKeyState("space") then
		Video.stop()
	end
end

local function startVideo()
	setTimer(function ()
		isLogoVisible = false
	end, 2150, 1)
	setTimer(function ()
		isBrowserVisible = true
		isLogoVisible = true
	end, 250, 1)
end

local function setupBrowser()
	loadBrowserURL(browser, "http://mta/local/html/video.html")
	addEventHandler("onClientBrowserDocumentReady", browser, startVideo)
end

addEvent("_dpIntroVideo.ended")
addEventHandler("_dpIntroVideo.ended", root, function ()
	Video.stop()
end)

function Video.start()
	if Video.active then
		return false
	end
	Video.active = true
	isBrowserVisible = false
	isSkipTextVisible = false
	skipTextAlpha = 0
	browser = Browser(screenWidth * videoScale, screenHeight * videoScale, true, false)

	logoTexture = exports.dpAssets:createTexture("logo_red.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	logoWidth = screenWidth * 0.6
	logoHeight = logoWidth

	addEventHandler("onClientBrowserCreated", browser, setupBrowser)
	addEventHandler("onClientRender", root, draw)
	return true
end

function Video.stop()
	if not Video.active then
		return false
	end
	removeEventHandler("onClientBrowserDocumentReady", browser, startVideo)
	Video.active = false
	destroyElement(browser)
	browser = nil
	removeEventHandler("onClientRender", root, draw)	
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Video.start()
end)