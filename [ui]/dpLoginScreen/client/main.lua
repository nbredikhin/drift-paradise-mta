local HIDE_CHAT = false

local screenWidth, screenHeight = guiGetScreenSize()
local backgroundScale = screenHeight / 720
local backgroundWidth, backgroundHeight = 1280 * backgroundScale, 720 * backgroundScale
local animationProgress = 0
local ANIMATION_SPEED = 0.01

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
	if visible then
		addEventHandler("onClientRender", root, draw)
		exports.dpUI:showScreen("login", {animation = true})
		animationProgress = 0
	else
		exports.dpUI:hideScreen("login")
		removeEventHandler("onClientRender", root, draw)
	end
	showCursor(visible)
end

addEvent("dpUI.login.startGameClick", false)
addEventHandler("dpUI.login.startGameClick", root, function (username, password)
	if not username or string.len(username) < 1 then		
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("login_panel_auth_error"), 
			exports.dpLang:getString("login_panel_err_enter_username")
		)
		return
	end
	if not password or string.len(password) < 1 then
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("login_panel_auth_error"), 
			exports.dpLang:getString("login_panel_err_enter_password")
		)
		return
	end	
	if not exports.dpAccounts:login(username, password) then
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("login_panel_auth_error"), 
			exports.dpLang:getString("login_panel_err_login_unknown")
		)
		return
	end
end)

addEvent("dpAccounts.loginResponse", true)
addEventHandler("dpAccounts.loginResponse", root, function (success, err)
	if not success then
		outputDebugString("Error: " .. tostring(err))
		local errorText = exports.dpLang:getString("login_panel_err_login_unknown")
		if err == "incorrect_password" then
			errorText = exports.dpLang:getString("login_panel_err_bad_password")
		elseif err == "user_not_found" then
			errorText = exports.dpLang:getString("login_panel_err_user_not_found")
		elseif err == "already_logged_in" then
			errorText = exports.dpLang:getString("login_panel_err_account_in_use")
		end
		exports.dpUI:showMessageBox(exports.dpLang:getString("login_panel_auth_error"),  errorText)
		return
	end
	setVisible(false)
	outputChatBox(exports.dpLang:getString("chat_message_login_success"), 0, 255, 0)
end)

-- Регистрация
addEvent("dpUI.login.registerClick", false)
addEventHandler("dpUI.login.registerClick", root, function (username, password)
	if not username or string.len(username) < 1 then
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("login_panel_register_error"), 
			exports.dpLang:getString("login_panel_err_enter_username")
		)
		return
	end
	if not password or string.len(password) < 1 then
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("login_panel_register_error"), 
			exports.dpLang:getString("login_panel_err_enter_password")
		)
		return
	end	
	if not exports.dpAccounts:register(username, password) then
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("login_panel_register_error"),
			exports.dpLang:getString("login_panel_err_register_unknown")
		)
		return
	end
end)

addEvent("dpAccounts.registerResponse", true)
addEventHandler("dpAccounts.registerResponse", root, function (success, err)
	if not success then
		outputDebugString("Error: " .. tostring(err))
		local errorText = exports.dpLang:getString("login_panel_err_register_unknown")
		exports.dpUI:showMessageBox(exports.dpLang:getString("login_panel_register_error"), errorText)
		return
	end
	exports.dpUI:showScreen("login")
	exports.dpUI:showMessageBox("Drift Paradise", "Вы успешно зарегистрировались!")
end)

-- Смена языка
addEvent("dpUI.login.languageClick", false)
addEventHandler("dpUI.login.languageClick", root, function(language)	
	if language == "ru" then
		language = "russian"
	else
		language = "english"
	end
	exports.dpLang:setLanguage(language)
	setVisible(false)
	setVisible(true)
end)