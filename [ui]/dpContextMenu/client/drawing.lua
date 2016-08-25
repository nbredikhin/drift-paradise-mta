local screenSize = Vector2(guiGetScreenSize())
local currentMenu = false
local targetElement

local menuScreenPosition = Vector2()

local menuItemHeight = 30
local menuHeaderHeight = 35

local itemTextOffset = 15

local headerBackgroundColor = {20, 20, 20}
local menuBackgroundColor = {228, 228, 228}
local menuSelectionColor = {212, 0, 40}

local headerTextColor = {255, 255, 255}
local menuTextColor = {0, 0, 0}
local menuSelectedTextColor = {255, 255, 255}
local menuDisabledTextColor = {70, 70, 70}

local MENU_MIN_WIDTH = 150
local menuWidth = 150
local itemFont
local titleFont

local menuAlpha = 200
local highlightedItem

addEventHandler("onClientRender", root, function ()
	if not currentMenu then
		return false
	end

	local x, y = menuScreenPosition.x, menuScreenPosition.y
	local mx, my = getCursorPosition()
	if not mx then
		return
	end
	mx = mx * screenSize.x
	my = my * screenSize.y

	dxDrawRectangle(x, y, menuWidth, menuHeaderHeight, tocolor(headerBackgroundColor[1], headerBackgroundColor[2], headerBackgroundColor[3], menuAlpha))
	dxDrawText(
		currentMenu.title, 
		x + itemTextOffset, y, x + menuWidth, y + menuHeaderHeight, 
		tocolor(headerTextColor[1], headerTextColor[2], headerTextColor[3], menuAlpha),
		1, 
		titleFont,
		"left",
		"center"
	)
	y = y + menuHeaderHeight
	highlightedItem = nil
	for i, item in ipairs(currentMenu.items) do
		local bgColor = menuBackgroundColor
		local textColor = menuTextColor
		if mx > x and mx < x + menuWidth and my > y and my < y + menuItemHeight then
			bgColor = menuSelectionColor
			textColor = menuSelectedTextColor
			if item.state then
				highlightedItem = item
			end
		end
		if item.state == false then
			bgColor = menuBackgroundColor
			textColor = menuDisabledTextColor
		end
		dxDrawRectangle(x, y, menuWidth, menuItemHeight, tocolor(bgColor[1], bgColor[2], bgColor[3], menuAlpha))
		dxDrawText(
			item.text, 
			x + itemTextOffset, y, x + menuWidth, y + menuItemHeight, 
			tocolor(textColor[1], textColor[2], textColor[3], menuAlpha),
			1, 
			itemFont,
			"left",
			"center"
		)
		y = y + menuItemHeight
	end

	if getKeyState("mouse1") then		
		if highlightedItem and highlightedItem.enabled ~= false and type(highlightedItem.click) == "function" then
			highlightedItem.click(targetElement)
		end
		hideMenu()
	end
end)

function showMenu(menu, element)
	if type(menu) ~= "table" then
		return false
	end
	if not isElement(element) then
		return false
	end
	currentMenu = menu

	if type(currentMenu.init) == "function" then
		local show = currentMenu.init(currentMenu, element)
		if show == false then
			hideMenu()
			return
		end
	end	

	toggleControl("fire", false)

	local maxWidth = 0
	for i, item in ipairs(currentMenu.items) do
		if type(item.enabled) == "function" then
			item.state = item.enabled(element)
		elseif item.enabled == nil then
			item.state = true
		else
			item.state = not not item.enabled
		end
		if type(item.locale) == "string" then
			item.text = exports.dpLang:getString(item.locale)
		end
		if type(item.getText) == "function" then
			item.text = item.getText(element)
		end
		local width = dxGetTextWidth(item.text, 1, itemFont)
		if width > maxWidth then
			maxWidth = width
		end
	end
	local titleWidth = dxGetTextWidth(currentMenu.title, 1, titleFont)
	if titleWidth > maxWidth then
		maxWidth = titleWidth
	end

	menuWidth = math.max(MENU_MIN_WIDTH, maxWidth + itemTextOffset * 2)
	local totalHeight = menuItemHeight * #currentMenu.items + menuHeaderHeight
	targetElement = element

	local mx, my = getCursorPosition()
	mx = mx * screenSize.x
	my = my * screenSize.y

	menuScreenPosition = Vector2(math.min(mx, screenSize.x - menuWidth), math.min(my, screenSize.y - totalHeight))
	localPlayer:setData("activeUI", "contextMenu")
end

function isMenuVisible()
	return not not currentMenu
end

function hideMenu()
	localPlayer:setData("activeUI", false)
	setTimer(function() toggleControl("fire", true) end, 200, 1)
	currentMenu = false
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	titleFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)
	itemFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 12)
end)