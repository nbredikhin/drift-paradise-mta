ScreenRender = {}
local SCREENS_ROOT_URL = "screens/"

local function readFile(path)
	local file = File(path)
	if not file then
		return false
	end
	local str = file:read(file.size)
	file:close()
	return str
end

local function replaceTemplate(value)
	return "X"
end

local function renderFile(path)
	local fileContents = readFile(path)
	if not fileContents then
		return false
	end
	fileContents = string.gsub(fileContents, "{{(.-)}}", replaceTemplate)
	return fileContents
end

local function setupStaticFilesHandlers(browser, resourceName)
	local staticJSON = readFile(":" .. resourceName .. "/static.json")
	local staticFiles = fromJSON(staticJSON)
	if not staticFiles then
		return false
	end
	for i, path in ipairs(staticFiles) do
		local str = renderFile(":" .. resourceName .. "/" .. path)
		local ajaxURL = SCREENS_ROOT_URL .. resourceName .. "/" .. path
		browser:setAjaxHandler(ajaxURL, function ()
			return str
		end)
		outputDebugString("Set ajax: " .. ajaxURL)
	end
end

function ScreenRender.renderScreen(browser, resourceName)
	if not isElement(browser) then
		return false
	end
	if type(resourceName) ~= "string" then
		return false
	end
	local screenURL = "http://mta/" .. resourceName .. "/html/index.html"
	setupStaticFilesHandlers(browser, resourceName)
	browser:setAjaxHandler(screenURL, function ()
		return screenHTML
	end)
	browser:loadURL(SCREENS_ROOT_URL .. resourceName .. "/html/index.html")
	outputDebugString("Open: " .. SCREENS_ROOT_URL .. resourceName .. "/html/index.html")
end