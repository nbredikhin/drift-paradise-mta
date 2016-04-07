ScreenRender = {}
local SCREENS_PATH = "html/screens/"
local SCREENS_URL = "http://mta/local/" .. SCREENS_PATH
local INDEX_URL = "http://mta/local/html/index.html"
local STOP_RENDERING_TIMEOUT = 5000
local isReady = false
local renderWhenReady = nil
local currentScreenURL = nil
local stopRenderingTimer

setDevelopmentMode(true, true)

local function passLocales()
	local strings = exports.dpLang:getAllStrings()
	if strings then
		ScreenManager.browser:executeJavascript("Screens.passLocales('" .. toJSON(strings) .."');")	
	end	
end

addEvent("dpLang.languageChanged", false)
addEventHandler("dpLang.languageChanged", root, function (newLanguage)
	passLocales()
end)

local function stopRendering()
	ScreenManager.browser.renderingPaused = true
	if isTimer(stopRenderingTimer) then
		killTimer(stopRenderingTimer)
	end
end

function ScreenRender.start()
	addEventHandler("onClientBrowserDocumentReady", ScreenManager.browser, function (url)
		if url == INDEX_URL then
			isReady = true
			if renderWhenReady then
				ScreenRender.renderScreen(renderWhenReady)
				renderWhenReady = nil
			end						
			passLocales()	
		end
	end)
	ScreenManager.browser:loadURL(INDEX_URL)
end

function ScreenRender.renderScreen(name, data)
	if not isReady then
		renderWhenReady = name
		return false
	end
	if type(name) ~= "string" then
		return false
	end
	local data = {
		message = "Wherry" .. math.random(1000, 9999),
		users = {
			{id = 1, name = "User1", score = 123},
			{id = 2, name = "User2", score = 124},																		
		}
	}
	if isTimer(stopRenderingTimer) then
		killTimer(stopRenderingTimer)
	end	
	ScreenManager.browser.renderingPaused = false
	ScreenManager.browser:executeJavascript("Screens.load(\"" .. name .. "\", '" .. toJSON(data) .."');")
end

function ScreenRender.clear()
	if not isReady then 
		return false
	end
	if isTimer(stopRenderingTimer) then
		killTimer(stopRenderingTimer)
	end
	stopRenderingTimer = setTimer(stopRendering, STOP_RENDERING_TIMEOUT, 1)
	return ScreenManager.browser:executeJavascript("Screens.unload();")
end