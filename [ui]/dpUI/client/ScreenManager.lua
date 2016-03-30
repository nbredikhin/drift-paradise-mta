ScreenManager = {}
local screens = {}
local activeScreen

function ScreenManager.addScreen(name, resource)
	if type(name) ~= "string" then
		return false
	end
	if not isElement(resource) then
		return false
	end
	if screens[name] then
		ScreenManager.removeScreen(resource)
	end
	resource:setData("screen_name", name)
	screens[name] = resource
	outputDebugString(string.format("ScreenManager: added screen %q", name))
	return true
end

function ScreenManager.removeScreen(name)
	if type(name) ~= "string" then
		return false
	end
	outputDebugString(string.format("ScreenManager: removed screen %q", name))
	screens[name] = nil
	return true
end

function ScreenManager.showScreen(name)
	local resource = screens[name]
	if not isElement(resource) then
		return false
	end
	if activeScreen then
		ScreenManager.hide()
	end
	activeScreen = name
	ScreenView.show(":" .. resource.name)
	return true
end

function ScreenManager.hide()
	if not activeScreen then
		return false
	end
	activeScreen = nil
	return ScreenView.hide()
end

addEventHandler("onClientResourceStop", root, function (resource)
	ScreenManager.removeScreen(resource.rootElement:getData("screen_name"))
end)