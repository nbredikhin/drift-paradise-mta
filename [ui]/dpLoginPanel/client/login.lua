local currentUsername, currentPassword

function startGameClick(username, password)
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
	currentUsername = username
	currentPassword = password
end

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
	Autologin.remember(currentUsername, currentPassword)
	outputChatBox(exports.dpLang:getString("chat_message_login_success"), 0, 255, 0)
end)

function registerClick(username, password)
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
end

addEvent("dpAccounts.registerResponse", true)
addEventHandler("dpAccounts.registerResponse", root, function (success, err)
	if not success then
		outputDebugString("Error: " .. tostring(err))
		local errorText = exports.dpLang:getString("login_panel_err_register_unknown")
		exports.dpUI:showMessageBox(exports.dpLang:getString("login_panel_register_error"), errorText)
		return
	end
	gotoLoginPanel()
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