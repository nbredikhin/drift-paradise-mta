ScreenManager = {}
local screens = {}
local activeScreen

function ScreenManager.addScreen(name, resourceName, resourceRoot)
	if type(name) ~= "string" then
		return false
	end
	if not isElement(resourceRoot) then
		return false
	end
	if screens[name] then
		ScreenManager.removeScreen(resource)
	end
	screens[name] = {
		resourceName = resourceName,
		resourceRoot = resourceRoot
	}
	resourceRoot:setData("screen_name", name)
	outputDebugString(string.format("ScreenManager: added screen: %q", name))
	return true
end

function ScreenManager.removeScreen(name)
	if type(name) ~= "string" then
		return false
	end
	if not screens[name] then
		return false
	end
	if isElement(screens[name].resourceRoot) then
		screens[name].resourceRoot:setData("screen_name", nil)
	end
	screens[name] = nil
	outputDebugString(string.format("ScreenManager: removed screen: %q", name))
	return true
end

function ScreenManager.showScreen(name)
	if not screens[name] or not isElement(screens[name].resourceRoot) then
		return false
	end
	if activeScreen then
		ScreenManager.hide()
	end
	activeScreen = name
	return ScreenView.show(screens[name].resourceName)
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