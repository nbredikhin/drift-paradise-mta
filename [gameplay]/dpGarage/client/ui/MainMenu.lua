MainMenu = {}
local screenSize = Vector2(guiGetScreenSize())
local position = Vector3 { x = 2918.205, y = -3188.340, z = 2535.517 }
local worldSize = Vector2(1.5, 2)
local renderSize = Vector2(600, 800)
local renderTarget
local menuColor = tocolor(255, 255, 255, 230)
local highlightedColor = tocolor(29, 29, 29)
local selectedColor = tocolor(212, 0, 40)
local menuFont
local logoTexture
local camera

local itemHeight = 110
local currentItem = 1
local highlightItem = 0
local itemFontSize = 36
local menuItems = {
	"Выехать в город",
	"Кастомизация",
	"Настройки",
	"Продажа авто",
	"Выход"
}

local function drawMenu()
	dxSetRenderTarget(renderTarget, true)
	local y = 0
	dxDrawImage(0, 0, renderSize.x, renderSize.x * 0.3375, logoTexture)
	y = y + renderSize.x * 0.3375	
	for i, text in ipairs(menuItems) do
		if i == currentItem then
			dxDrawRectangle(0, y, renderSize.x, itemHeight, selectedColor)
		elseif i == highlightItem then
			dxDrawRectangle(0, y, renderSize.x, itemHeight, highlightedColor)
		else
			dxDrawRectangle(0, y, renderSize.x, itemHeight, tocolor(42, 40, 41))
		end
		dxDrawText(text, 0, y, renderSize.x, y + itemHeight, tocolor(255, 255, 255), 1, menuFont, "center", "center")
		y = y + itemHeight
	end
	dxSetRenderTarget()
end

local function menuMove(_, _, step)
	currentItem = currentItem + step
	if currentItem < 1 then
		currentItem = #menuItems 
	elseif currentItem > #menuItems then
		currentItem = 1
	end

	drawMenu()
end

function MainMenu.start()
	if not isElement(renderTarget) then 
		renderTarget = dxCreateRenderTarget(renderSize.x, renderSize.y, true)
	end
	logoTexture = exports.dpAssets:createTexture("logo.png")
	menuFont = exports.dpAssets:createFont("Roboto-Regular.ttf", itemFontSize)
	camera = getCamera()

	bindKey("arrow_u", "down", menuMove, -1)
	bindKey("arrow_d", "down", menuMove, 1)

	drawMenu()
end

function MainMenu.stop()
	if isElement(renderTarget) then destroyElement(renderTarget) end
	renderTarget = nil
	if isElement(logoTexture) then destroyElement(logoTexture) end
	if isElement(menuFont) then destroyElement(menuFont) end

	unbindKey("arrow_u", "down", menuMove)
	unbindKey("arrow_d", "down", menuMove)	
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