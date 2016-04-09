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
		exports.dpUI:showMessageBox("Ошибка авторизации", "Введите имя пользователя")
		return
	end
	if not password or string.len(password) < 1 then
		exports.dpUI:showMessageBox("Ошибка авторизации", "Введите пароль")
		return
	end	
	if not exports.dpAccounts:login(username, password) then
		exports.dpUI:showMessageBox("Ошибка авторизации", "Не удалось авторизоваться")
		return
	end
end)

addEvent("dpAccounts.loginResponse", true)
addEventHandler("dpAccounts.loginResponse", root, function (success, err)
	if not success then
		outputDebugString("Error: " .. tostring(err))
		local errorText = "Не удалось авторизоваться"
		if err == "incorrect_password" then
			errorText = "Неверный пароль"
		elseif err == "user_not_found" then
			errorText = "Пользователь с таким именем не найден"
		end
		exports.dpUI:showMessageBox("Ошибка авторизации", errorText)
		return
	end
	setVisible(false)
	outputChatBox("Вы успешно вошли", 0, 255, 0)
end)

-- Регистрация
addEvent("dpUI.login.registerClick", false)
addEventHandler("dpUI.login.registerClick", root, function (username, password)
	if not username or string.len(username) < 1 then
		exports.dpUI:showMessageBox("Ошибка регистрации", "Введите имя пользователя")
		return
	end
	if not password or string.len(password) < 1 then
		exports.dpUI:showMessageBox("Ошибка регистрации", "Введите пароль")
		return
	end	
	if not exports.dpAccounts:register(username, password) then
		exports.dpUI:showMessageBox("Ошибка регистрации", "Не удалось зарегистрироваться")
		return
	end
end)

addEvent("dpAccounts.registerResponse", true)
addEventHandler("dpAccounts.registerResponse", root, function (success, err)
	if not success then
		outputDebugString("Error: " .. tostring(err))
		local errorText = "Не удалось зарегистрироваться"
		exports.dpUI:showMessageBox("Ошибка регистрации", errorText)
		return
	end
	exports.dpUI:showScreen("login")
	exports.dpUI:showMessageBox("Drift Paradise", "Вы успешно зарегистрировались!")
end)