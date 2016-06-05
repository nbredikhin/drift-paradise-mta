GarageUI = {}
local screenWidth, screenHeight = guiGetScreenSize()
local screenSize = Vector2()
local renderTarget
local shadowTexture
local screenManager
local isVisible = true
local helpText = "..."

local function draw()
	dxDrawImage(0, 0, screenWidth, screenHeight, shadowTexture, 0, 0, 0, tocolor(0, 0, 0, 200))
	if not isVisible then
		return
	end
	if screenManager then
		screenManager:draw()

		local helpTextAlpha = 255
		if screenManager.activeScreen then
			helpTextAlpha = helpTextAlpha * screenManager.activeScreen.fadeProgress
		end
		dxSetRenderTarget(renderTarget)
		dxDrawText(
			helpText, 
			0, screenSize.y - 50, 
			screenSize.x, screenSize.y, 
			tocolor(255, 255, 255, helpTextAlpha), 
			1, 
			Assets.fonts.helpText,
			"center",
			"center"
		)	
		dxSetRenderTarget()
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
	if not isDown or CameraManager.isMouseLookEnabled() or isMTAWindowActive() then
		return
	end
	if screenManager then
		screenManager:onKey(button)
	end
end

function GarageUI.start()
	isVisible = true
	screenSize = Vector2(exports.dpUI:getScreenSize())
	renderTarget = exports.dpUI:getRenderTarget()

	shadowTexture = exports.dpAssets:createTexture("screen_shadow.png")
	GarageUI.resetHelpText()
	-- Создание менеджера экранов
	screenManager = ScreenManager()
	-- Переход на начальный экран
	local screen = MainScreen()
	screenManager:showScreen(screen)
	setTimer(function ()
		screenManager:showScreen(StickerSelectionScreen())
	end, 700, 1)
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

function GarageUI.setHelpText(text)
	helpText = text
end

function GarageUI.resetHelpText()
	helpText = string.format(
		exports.dpLang:getString("garage_help_text"), 
		exports.dpLang:getString("controls_arrows"), 
		"ENTER", 
		"BACKSPACE",
		exports.dpLang:getString("controls_mouse")
	)
end