local CURSOR_BUTTON = "f2"
local registeredMenus = {}

function registerContextMenu(targetElementType, menu)
	registeredMenus[targetElementType] = menu
end

function getContextMenu(targetElementType)
	return registeredMenus[targetElementType]
end

addEventHandler("onClientClick", root, function(button, state, x, y, worldX, worldY, worldZ, targetElement)
	if button ~= "right" or state ~= "down" then
		return
	end
	if isMenuVisible() then
		hideMenu()
	end	
	if not isElement(targetElement) then
		return
	end
	if not localPlayer:getData("username") or localPlayer:getData("dpCore.state") then
		return
	end
	if localPlayer:getData("dpCore.state") or exports.dpMainPanel:isVisible() then
		return
	end
	if localPlayer:getData("activeUI") then
		return
	end	
	if registeredMenus[targetElement.type] then
		showMenu(registeredMenus[targetElement.type], targetElement)
	end
end)

bindKey(CURSOR_BUTTON, "down", function() 
	if localPlayer:getData("dpCore.state") or (localPlayer:getData("activeUI") and localPlayer:getData("activeUI") ~= "contextMenu") then
		return
	end
	showCursor(not isCursorShowing(), false) 
	if not isCursorShowing() then
		hideMenu()
	end
end)