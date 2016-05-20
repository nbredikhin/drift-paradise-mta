local PRINT_META_XML = false
local function printMetaExport(name)
	if PRINT_META_XML then
		outputConsole('\t<export type="client" function="' .. tostring(name) ..'"/>')
	end
end

function getScreenSize()
	return getLimitedScreenSize()
end
printMetaExport("getScreenSize")

function setTheme(...)
	return Colors.setTheme(...)
end
printMetaExport("setTheme")

function getThemeColor(...)
	return Colors.getThemeColor(...)
end
printMetaExport("getThemeColor")

function getThemeName(...)
	return Colors.getThemeName(...)
end
printMetaExport("getThemeName")

function showMessageBox(...)
	return MessageBox.show(...)
end
printMetaExport("showMessageBox")

function hideMessageBox(...)
	return MessageBox.hide(...)
end
printMetaExport("hideMessageBox")

function getRootWidget()
	Render.setupResource(sourceResourceRoot)
	return Render.resources[sourceResourceRoot].rootWidget.id
end
printMetaExport("getRootWidget")

function addChild(parent, child)
	if not child then
		child = Render.getWidgetById(sourceResourceRoot, parent)
		parent = Render.resources[sourceResourceRoot].rootWidget
	else
		parent = Render.getWidgetById(sourceResourceRoot, parent)
		child = Render.getWidgetById(sourceResourceRoot, child)
	end
	if not parent or not child then
		return false
	end
	return Widget.addChild(parent, child)
end
printMetaExport("addChild")

function removeChild(parent, child)
	parent = Render.getWidgetById(sourceResourceRoot, parent)
	child = Render.getWidgetById(sourceResourceRoot, child)
	if not parent or not child then
		return false
	end
	return Widget.removeChild(parent, child)
end
printMetaExport("removeChild")

local widgetsList = {
	"Rectangle",
	"Button",
	"Image",
	"TextField",
	"Input",
	"DpButton",
	"DpPanel",
	"DpInput",
	"DpLabel",
	"DpImageButton"
}

local function createWidgetProxy(name, resourceRoot, ...)
	local WidgetType = _G[name]
	if type(WidgetType) ~= "table" then
		outputDebugString("Error: Widget does not exist: " .. tostring(name))
		return false
	end
	local widget = WidgetType.create(...)
	if not widget then
		outputChatBox("Error: Failed to create widget: " .. tostring(name))
		return false
	end
	return Render.exportWidget(widget, resourceRoot)
end

-- Генерация экспортов для всех widget'ов
for i, name in ipairs(widgetsList) do
	_G["create" .. name] = function (...) 
		return createWidgetProxy(name, sourceResourceRoot, ...)
	end
	printMetaExport("create" .. name)
end


-- get set

local publicPropertiesList = {
	-- Base
	"x", "y", "width", "height", "color", "visible", "text",
	-- TextField
	"alignX", "alignY", "clip", "wordBreak", "colorCoded",
	-- Dp
	"colors", "type", "state"
}

for i, name in ipairs(publicPropertiesList) do
	local capitalizedName = exports.dpUtils:capitalizeString(name)
	_G["get" .. capitalizedName] = function(widget)
		widget = Render.getWidgetById(sourceResourceRoot, widget)
		if not widget then
			return false
		end
		return widget[name]
	end
	printMetaExport("get" .. capitalizedName)
	_G["set" .. capitalizedName] = function(widget, value)
		widget = Render.getWidgetById(sourceResourceRoot, widget)
		if not widget then
			return false
		end
		if value == nil then
			return false
		end
		if type(widget["set" .. capitalizedName]) == "function" then
			widget[name] = widget["set" .. capitalizedName](widget, value)
		else
			widget[name] = value
		end
		return true
	end	
	printMetaExport("set" .. capitalizedName)
end