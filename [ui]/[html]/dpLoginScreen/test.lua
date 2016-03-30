addEvent("dpAccounts.registerResponse", true)
addEventHandler("dpAccounts.registerResponse", root, function(success)
	if success then
		outputChatBox("success")
	else
		outputChatBox("error")
	end
end)

addCommandHandler("dp_register", function (cmd, username, password)
	if not exports.dpAccounts:register(username, password) then
		outputChatBox("Не удалось зарегистрировать аккаунт (client)")
		return
	end
end)

addEvent("dpAccounts.loginResponse", true)
addEventHandler("dpAccounts.loginResponse", root, function(success, errorType)
	if success then
		outputChatBox("Вы вошли")
	else
		outputChatBox("error: " .. tostring(errorType))
	end
end)

addCommandHandler("dp_login", function (cmd, username, password)
	if not exports.dpAccounts:login(username, password) then

		outputChatBox("Не удалось войти (client)")
		return
	end
end)

addEvent("dpAccounts.logoutResponse", true)
addEventHandler("dpAccounts.logoutResponse", root, function(success, errorType)
	if success then
		outputChatBox("Вы вышли")
	else
		outputChatBox("error")
	end
end)

addCommandHandler("dp_logout", function (cmd, username, password)
	if not exports.dpAccounts:logout() then
		outputChatBox("Ошибка")
		return
	end
end)