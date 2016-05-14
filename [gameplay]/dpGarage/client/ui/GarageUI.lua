GarageUI = {}
local screenWidth, screenHeight = guiGetScreenSize()
local shadowTexture
local screenManager

local function draw()
	dxDrawImage(0, 0, screenWidth, screenHeight, shadowTexture, 0, 0, 0, tocolor(0, 0, 0, 200))
	if screenManager then
		screenManager:draw()
	end
end

local function update(deltaTime)
	if screenManager then
		deltaTime = deltaTime / 1000
		screenManager:update(deltaTime)
	end
end

local function onKey(button, isDown)
	if not isDown then
		return
	end
	if screenManager then
		screenManager:onKey(button)
	end
end

function GarageUI.start()
	shadowTexture = exports.dpAssets:createTexture("screen_shadow.png")

	-- Создание менеджера экранов
	screenManager = ScreenManager()
	-- Переход на начальный экран
	screenManager:showScreen(MainScreen())

	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientKey", root, onKey)
end

function GarageUI.stop()
	screenManager:destroy()
	screenManager = nil

	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientKey", root, onKey)
	if isElement(shadowTexture) then
		destroyElement(shadowTexture)
	end	
end