local commandHandlers = {}

commandHandlers["cleardebug"] = function (tabName, command, ...)
	for i = 1, 25 do
		local text = " "
		for j = 1, i do
			text = text .. " "
		end
		outputDebugString(text)
	end
end

addEvent("dpChat.command", true)
addEventHandler("dpChat.command", root, function(tabName, command, ...)
	if commandHandlers[command] then
		if AntiFlood.isMuted() then
			AntiFlood.onMessage()
			Chat.message(tabName, "#FF0000" .. exports.dpLang:getString("chat_message_dont_flood"))
			return
		end
		commandHandlers[command](tabName, command, ...)
		AntiFlood.onMessage()
	end
end)
