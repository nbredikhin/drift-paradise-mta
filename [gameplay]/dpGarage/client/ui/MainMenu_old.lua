MainMenu = {}
local navigationDisabled = false
local screenSize = Vector2(guiGetScreenSize())
local position = Vector3 { x = 2918.205, y = -3188.340, z = 2535.517 }
local worldSize = Vector2(1.5, 2)
local renderSize = Vector2(375, 500)
local renderTarget

local menuColor = tocolor(255, 255, 255, 230)
local highlightedColor = tocolor(29, 29, 29)
local selectedColor = tocolor(212, 0, 40)

local camera

local itemHeight = renderSize.y * 0.12
local currentItem = 1
local highlightItem = 0

local menus = {}
menus.main = {
	{locale="garage_menu_go_city", action = function ()
		Garage.selectCarAndExit()
		navigationDisabled = true
	end},
	{locale="garage_menu_customize", show="customize"},
	{locale="garage_menu_settings", show="settings"},
	{locale="garage_menu_sell", action=function() 
	end},
	{locale="garage_menu_exit", action=function() 
		exitGarage()
		navigationDisabled = true
	end},
}
menus.customize = {
	{locale="garage_menu_customize_components"},
	{locale="garage_menu_customize_paint"},
	{locale="garage_menu_customize_stickers"},
	{locale="garage_menu_customize_config"},
	{locale="garage_menu_back", show="main"}
}
menus.settings = {
	{locale="garage_menu_settings_bumper"},
	{locale="garage_menu_back", show="main"}
}

local currentMenu
local menuItems = {}


local function drawMenu()
	dxSetRenderTarget(renderTarget, true)
	local y = 0
	local logoHeight = renderSize.x * 0.3375
	dxDrawImage(0, -120, renderSize.x, renderSize.x, Assets.textures.logo)
	
	local arrowSize = renderSize.x / 4
	dxDrawImage((renderSize.x - arrowSize) / 2, logoHeight - 35 - math.sin(getTickCount() / 200) * 5, arrowSize, arrowSize, Assets.textures.arrow, -90, 0, 0)
	y = y + logoHeight + 30
	for i, text in ipairs(menuItems) do
		local textAlpha = 200
		if i == currentItem then
			dxDrawRectangle(0, y, renderSize.x, itemHeight, selectedColor)
			if i == highlightItem then
				textAlpha = 255
			end
		elseif i == highlightItem then
			dxDrawRectangle(0, y, renderSize.x, itemHeight, highlightedColor)
			textAlpha = 255
		else
			dxDrawRectangle(0, y, renderSize.x, itemHeight, tocolor(42, 40, 41))
		end
		dxDrawText(text, 0, y, renderSize.x, y + itemHeight, tocolor(textAlpha, textAlpha, textAlpha), 1, Assets.fonts.menu, "center", "center")
		y = y + itemHeight
	end
	dxDrawImage((renderSize.x - arrowSize) / 2, y - itemHeight + 32 + math.sin(getTickCount() / 200) * 5, arrowSize, arrowSize, Assets.textures.arrow, 90, 0, 0)
	dxSetRenderTarget()
end

local function menuMove(_, _, step)
	if navigationDisabled then
		return
	end
	currentItem = currentItem + step
	if currentItem < 1 then
		currentItem = #menuItems 
	elseif currentItem > #menuItems then
		currentItem = 1
	end
end

local function openMenu(name)
	if not menus[name] then
		error("No such menu: " .. tostring(name))
	end
	currentMenu = menus[name]
	currentItem = 1
	highlightItem = 0
	menuItems = {}
	for i, item in ipairs(currentMenu) do
		table.insert(menuItems, exports.dpLang:getString(item.locale))
	end
end

local function menuSelect()
	if navigationDisabled then
		return
	end
	if currentMenu[currentItem] then
		if type(currentMenu[currentItem].action) == "function" then
			currentMenu[currentItem].action()
		end
		if currentMenu[currentItem].show then
			openMenu( currentMenu[currentItem].show)
		end		
	end
end

local function menuBack()
	openMenu("main")
end

function MainMenu.start()
	if not isElement(renderTarget) then 
		renderTarget = dxCreateRenderTarget(renderSize.x, renderSize.y, true)
	end
	navigationDisabled = false
	camera = getCamera()

	bindKey("arrow_u", "down", menuMove, -1)
	bindKey("arrow_d", "down", menuMove, 1)
	bindKey("enter", "down", menuSelect)
	bindKey("backspace", "down", menuBack)
	openMenu("main")
end

function MainMenu.stop()
	if isElement(renderTarget) then destroyElement(renderTarget) end
	renderTarget = nil

	unbindKey("arrow_u", "down", menuMove)
	unbindKey("arrow_d", "down", menuMove)	
	unbindKey("enter", "down", menuSelect)
	unbindKey("backspace", "down", menuBack)
end

function MainMenu.draw()
	local mx, my = getCursorPosition()
	if not mx then mx = 0 my = 0 end

	local _, _, z = getWorldFromScreenPosition(mx * screenSize.x, my * screenSize.y, 10)
	drawMenu()
	-- Отрисовка меню
	local halfHeight = Vector3(0, 0, worldSize.y / 2)

	-- Мышь
	if mx < 0.4 and mx > 0.05 then
		local p = (position.z - z) / halfHeight.z * 0.5 + 0.1
		p = math.floor(p / 0.25)
		highlightItem = p + 2
		if getKeyState("mouse1") then
			currentItem = highlightItem
		end
	else
		highlightItem = 0
	end

	dxDrawMaterialLine3D(
		position + halfHeight + Vector3(0.1 * my - 0.1, 0.1 * my - 0.1, 0), 
		position - halfHeight, 
		renderTarget, 
		worldSize.x, 
		menuColor, 
		camera.matrix:transformPosition(3 + 1 * mx, 0, 0)
	)
end