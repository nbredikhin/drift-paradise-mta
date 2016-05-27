GarageUI = {}
local screenWidth, screenHeight = guiGetScreenSize()
local shadowTexture
local screenManager
local isVisible = true
local helpText = "..."

local function draw()
	dxDrawImage(0, 0, screenWidth, screenHeight, shadowTexture, 0, 0, 0, tocolor(0, 0, 0, 200))
	if not isVisible then
		return
	end
	dxDrawText(
		helpText, 
		0, screenHeight - 50, 
		screenWidth, screenHeight, 
		tocolor(255, 255, 255, 150), 
		1, 
		Assets.fonts.helpText,
		"center",
		"center"
	)
	if screenManager then
		screenManager:draw()
	end
end

local function update(deltaTime)
	if not isVisible then
		return
	end	
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
	isVisible = true
	shadowTexture = exports.dpAssets:createTexture("screen_shadow.png")
	helpText = string.format(
		exports.dpLang:getString("garage_help_text"), 
		exports.dpLang:getString("controls_arrows"), 
		"ENTER", 
		"BACKSPACE",
		exports.dpLang:getString("controls_mouse")
	)
	-- Создание менеджера экранов
	screenManager = ScreenManager()
	-- Переход на начальный экран
	local screen = MainScreen()
	screenManager:showScreen(screen)
	-- setTimer(function ()
	-- 	screenManager:showScreen(ConfigurationsScreen())
	-- end, 700, 1)
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

function GarageUI.showSaving()
	
end

function GarageUI.setVisible(visible)
	isVisible = not not visible
end