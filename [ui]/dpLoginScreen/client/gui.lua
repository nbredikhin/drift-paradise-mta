local UI = exports.dpUI
local HIDE_CHAT = false
local screenWidth, screenHeight = exports.dpUI:getScreenSize()
local backgroundScale = screenHeight / 720
local backgroundWidth, backgroundHeight = 1280 * backgroundScale, 720 * backgroundScale
local animationProgress = 0
local ANIMATION_SPEED = 0.01
local loginPanel = {}
local registerPanel = {}

local function draw()
	animationProgress = math.min(1, animationProgress + ANIMATION_SPEED)
	dxDrawImage(0, 0, backgroundWidth, backgroundHeight, "assets/background.jpg", 0, 0, 0, tocolor(255, 255, 255, 255 * animationProgress))
end

function setVisible(visible)
	visible = not not visible
	if HIDE_CHAT then
		showChat(not visible)
	end
	exports.dpHUD:setVisible(not visible)

	UI:setVisible(loginPanel.panel, visible)
	UI:setVisible(registerPanel.panel, false)

	if visible then
		addEventHandler("onClientRender", root, draw)
		animationProgress = 0
	else
		removeEventHandler("onClientRender", root, draw)
	end
	showCursor(visible)
end

local function createLoginPanel()
	local panelWidth = 550
	local panelHeight = 260
	local panel = UI:createDpPanel({
		x = (screenWidth - panelWidth) / 2, 
		y = (screenHeight - panelHeight) / 1.8,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(panel)

	local logoTexture = exports.dpAssets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	local logoWidth = 415
	local logoHeight = textureHeight * 415 / textureWidth
	local logoImage = UI:createImage({
		x = (panelWidth - logoWidth) / 2,
		y = -logoHeight - 25,
		width = logoWidth, 
		height = logoHeight,
		texture = logoTexture
	})
	UI:addChild(panel, logoImage)

	local startGameButton = UI:createDpButton({
		x = 0, y = 0,
		width = panelWidth / 2,
		height = 55,
		type = "default_dark",
		text = "Начать игру",
		locale = "login_panel_start_game_button"
	})
	UI:addChild(panel, startGameButton)

	local registerButton = UI:createDpButton({
		x = panelWidth / 2, y = 0,
		width = panelWidth / 2,
		height = 55,
		type = "primary",
		text = "Регистрация",
		locale = "login_panel_register_button_toggle"
	})
	UI:addChild(panel, registerButton)	

	local usernameInput = UI:createDpInput({
		x = 50,
		y = 90,
		width = 450,
		height = 50,
		type = "dark",
		placeholder = "Имя пользователя",
		locale = "login_panel_username_label"
	})
	UI:addChild(panel, usernameInput)

	local passwordInput = UI:createDpInput({
		x = 50,
		y = 160,
		width = 450,
		height = 50,
		type = "dark",
		placeholder = "Пароль",
		masked = true,
		locale = "login_panel_password_label"
	})
	UI:addChild(panel, passwordInput)	
	UI:setVisible(panel, false)
		
	loginPanel.registerButton = registerButton
	loginPanel.startGameButton = startGameButton
	loginPanel.password = passwordInput
	loginPanel.username = usernameInput
	loginPanel.panel = panel
end

local function createRegisterPanel()
	local panelWidth = 550
	local panelHeight = 340
	local panel = UI:createDpPanel({
		x = (screenWidth - panelWidth) / 2, 
		y = (screenHeight - panelHeight) / 1.7,
		width = panelWidth, height = panelHeight,
		type = "dark"
	})
	UI:addChild(panel)

	local logoTexture = exports.dpAssets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	local logoWidth = 415
	local logoHeight = textureHeight * 415 / textureWidth
	local logoImage = UI:createImage({
		x = (panelWidth - logoWidth) / 2,
		y = -logoHeight - 25,
		width = logoWidth, 
		height = logoHeight,
		texture = logoTexture
	})
	UI:addChild(panel, logoImage)

	local languageLabelWidth = 118
	local languageLabel = UI:createDpLabel({
		x = 50,
		y = 40,
		width = languageLabelWidth,
		wordBreak = false,
		clip = true,
		height = 50,
		alignX = "left",
		alignY = "top",
		locale = "login_panel_language"
	})
	UI:addChild(panel, languageLabel)

	local languageEn = UI:createDpImageButton({
		x = 50 + languageLabelWidth + 7, y = 40,
		width = 27, height = 27,
		texture = dxCreateTexture("assets/en.png") 
	})
	UI:addChild(panel, languageEn)

	local languageRu = UI:createDpImageButton({
		x = 50 + languageLabelWidth + 7 + 27 + 10, y = 40,
		width = 27, height = 27,
		texture = dxCreateTexture("assets/ru.png") 
	})
	UI:addChild(panel, languageRu)	

	local usernameInput = UI:createDpInput({
		x = 50,
		y = 120,
		width = 450,
		height = 50,
		type = "dark",
		locale = "login_panel_username_label"
	})
	UI:addChild(panel, usernameInput)

	local passwordInput = UI:createDpInput({
		x = 50,
		y = 190,
		width = 450,
		height = 50,
		type = "dark",
		masked = true,
		locale = "login_panel_password_label"
	})
	UI:addChild(panel, passwordInput)	

	local backButton = UI:createDpButton({
		x = 0, 
		y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "default_dark",
		text = "Назад",
		locale = "login_panel_back"
	})
	UI:addChild(panel, backButton)

	local registerButton = UI:createDpButton({
		x = panelWidth / 2, 
		y = panelHeight - 55,
		width = panelWidth / 2,
		height = 55,
		type = "primary",
		text = "Зарегистрироваться",
		locale = "login_panel_register_button"
	})
	UI:addChild(panel, registerButton)	

	UI:setVisible(panel, false)
	registerPanel.panel = panel
	registerPanel.registerButton = registerButton
	registerPanel.backButton = backButton
	registerPanel.password = passwordInput
	registerPanel.username = usernameInput	
	registerPanel.langButtons = {
		en = languageEn,
		ru = languageRu
	}
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	createLoginPanel()
	createRegisterPanel()
end)

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function(widget)
	-- Переключение панелей
	if widget == loginPanel.registerButton then
		UI:setVisible(loginPanel.panel, false)
		UI:setVisible(registerPanel.panel, true)
	elseif widget == registerPanel.backButton then
		UI:setVisible(loginPanel.panel, true)
		UI:setVisible(registerPanel.panel, false)
	-- Переключение языка
	elseif widget == registerPanel.langButtons.en then
		exports.dpLang:setLanguage("english")
	elseif widget == registerPanel.langButtons.ru then
		exports.dpLang:setLanguage("russian")
	-- Кнопка входа
	elseif widget == loginPanel.startGameButton then
		startGameClick(UI:getText(loginPanel.username), UI:getText(loginPanel.password))
	-- Кнопка регистрации
	elseif widget == registerPanel.registerButton then
		registerClick(UI:getText(registerPanel.username), UI:getText(registerPanel.password))
	end
end)