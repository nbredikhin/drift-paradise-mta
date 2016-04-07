local screenWidth, screenHeight = guiGetScreenSize()
local backgroundScale = screenHeight / 720
local backgroundWidth, backgroundHeight = 1280 * backgroundScale, 720 * backgroundScale

local function draw()
	dxDrawImage(0, 0, backgroundWidth, backgroundHeight, "assets/background.jpg")
end

function setVisible(visible)
	visible = not not visible
	showChat(not visible)

	if visible then
		addEventHandler("onClientRender", root, draw)
		exports.dpUI:showScreen("login")
	else
		exports.dpUI:hideScreen("login")
		removeEventHandler("onClientRender", root, draw)
	end
	showCursor(visible)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	--setVisible(true)
end)

addEvent("dpUI.login.startGameClick", false)
addEventHandler("dpUI.login.startGameClick", root, function (username, password)
	outputDebugString("Login: " .. tostring(username) .. "; " .. tostring(password))
	exports.dpAccounts:login(username, password)
end)

addEvent("dpAccounts.loginResponse", true)
addEventHandler("dpAccounts.loginResponse", root, function (success, error)
	if not success then
		outputDebugString("Error: " .. tostring(error))
		return
	end
	setVisible(false)
	outputChatBox("Вы успешно вошли", 0, 255, 0)
end)