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

		local activeScreenAlpha = 255
		if screenManager.activeScreen then
			activeScreenAlpha = activeScreenAlpha * screenManager.activeScreen.fadeProgress
		end
		dxSetRenderTarget(renderTarget)
		dxDrawText(
			helpText, 
			0, screenSize.y - 50, 
			screenSize.x, screenSize.y, 
			tocolor(255, 255, 255, activeScreenAlpha), 
			1, 
			Assets.fonts.helpText,
			"center",
			"center"
		)
		-- Деньги игрока
		if screenManager.activeScreen then
			local primaryColor = tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3], 255)
			dxDrawText(
				"$#FFFFFF" .. tostring(localPlayer:getData("money")), 
				0, 20, 
				screenSize.x - 20, screenSize.y, 
				primaryColor, 
				1, 
				Assets.fonts.moneyText,
				"right",
				"top", 
				false, false, false, true
			)

			dxDrawText(
				exports.dpLang:getString("player_level") .. ": #FFFFFF" .. tostring(localPlayer:getData("level")), 
				0, 60, 
				screenSize.x - 20, screenSize.y, 
				primaryColor, 
				1, 
				Assets.fonts.levelText,
				"right",
				"top", 
				false, false, false, true
			)		

			if screenManager.activeScreen:class() == MainScreen then
				local color = "#FFFFFF"
				if localPlayer:getData("isPremium") then
					color = "#FFCC00"
				end
				dxDrawText(
						exports.dpLang:getString("garage_slot") 
						.. " " .. color 
						.. tostring(GarageCar.getCurrentSlot()) 
						.. " "
						.. exports.dpLang:getString("garage_slot_of")
						.. " "
						.. tostring(GarageCar.getSlotsCount()), 
					0, 0, 
					screenSize.x - 20, screenSize.y - 60, 
					primaryColor, 
					1, 
					Assets.fonts.slotsText,
					"right",
					"bottom", 
					false, false, false, true
				)		
			end
		end		
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
	if exports.dpTutorialMessage:isMessageVisible() then
		return 
	end	
	if screenManager then
		screenManager:onKey(button)
		if button == "enter" then
			exports.dpSounds:playSound("ui_select.wav")
		elseif button == "backspace" then
			exports.dpSounds:playSound("ui_back.wav")
		elseif string.find(button, "arrow") then
			exports.dpSounds:playSound("ui_change.wav")
		end
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
		--screenManager:showScreen(StickerEditorScreen("left"))
	end, 700, 1)
	exports.dpUI:forceRotation(0.5, 0.5)
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientKey", root, onKey)

	if localPlayer:getData("tutorialActive") then
		setTimer(function ()
		exports.dpTutorialMessage:showMessage(
			exports.dpLang:getString("tutorial_garage_title"), 
			exports.dpLang:getString("tutorial_garage_text"),
			utf8.lower(exports.dpLang:getString("player_level")))
		end, 1000, 1)
	end
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