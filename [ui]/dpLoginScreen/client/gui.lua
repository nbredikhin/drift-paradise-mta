local UI = exports.dpUI
local HIDE_CHAT = false
local screenWidth, screenHeight = guiGetScreenSize()
local backgroundScale = screenHeight / 720
local backgroundWidth, backgroundHeight = 1280 * backgroundScale, 720 * backgroundScale
local animationProgress = 0
local ANIMATION_SPEED = 0.01
local loginPanel

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
	UI:setVisible(loginPanel, visible)
	if visible then
		addEventHandler("onClientRender", root, draw)
		animationProgress = 0
	else
		removeEventHandler("onClientRender", root, draw)
	end
	showCursor(visible)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	local panelWidth = 550
	local panelHeight = 260
	local panel = UI:createDpPanel({
		x = (screenWidth - panelWidth) / 2, 
		y = (screenHeight - panelHeight) / 2,
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
		text = "Начать игру"
	})
	UI:addChild(panel, startGameButton)

	local registerButton = UI:createDpButton({
		x = panelWidth / 2, y = 0,
		width = panelWidth / 2,
		height = 55,
		type = "primary",
		text = "Регистрация"
	})
	UI:addChild(panel, registerButton)	

	local usernameInput = UI:createDpInput({
		x = 50,
		y = 90,
		width = 450,
		height = 50,
		type = "dark",
		text = "Имя пользователя"
	})
	UI:addChild(panel, usernameInput)

	local passwordInput = UI:createDpInput({
		x = 50,
		y = 160,
		width = 450,
		height = 50,
		type = "dark",
		text = "Пароль"
	})
	UI:addChild(panel, passwordInput)	
	loginPanel = panel
	setVisible(false)
	showCursor(true)
end)