addEvent("dpAccounts.register", true)
addEventHandler("dpAccounts.register", root, function(success)
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

addEvent("dpAccounts.login", true)
addEventHandler("dpAccounts.login", root, function(success, errorType)
	if success then
		outputChatBox("Вы вошли")
	else
		outputChatBox("error: " .. tostring(errorType))
	end
end)

addCommandHandler("dp_login", function (cmd, username, password)
	if not exports.dpAccounts:login(username, password) then
		outputChatBox("Не войти (client)")
		return
	end
end)