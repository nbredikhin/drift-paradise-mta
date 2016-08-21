local CURSOR_BUTTON = "u"
local registeredMenus = {}

function registerContextMenu(targetElementType, menu)
	registeredMenus[targetElementType] = menu
end

addEventHandler("onClientClick", root, function(button, state, x, y, worldX, worldY, worldZ, targetElement)
	if not targetElement then
		return
	end
	if button ~= "right" or state ~= "down" then
		return
	end
	if isMenuVisible() then
		hideMenu()
	end
	if registeredMenus[targetElement.type] then
		showMenu(registeredMenus[targetElement.type], targetElement)
	end
end)

bindKey(CURSOR_BUTTON, "down", function() 
	hideMenu()
	showCursor(not isCursorShowing()) 
end)