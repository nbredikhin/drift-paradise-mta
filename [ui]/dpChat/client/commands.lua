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

commandHandlers["me"] = function (tabName, command, ...)
	triggerServerEvent("dpChat.me", root, tabName, table.concat({...}, " "))
end

addEvent("dpChat.command")
addEventHandler("dpChat.command", root, function(tabName, command, ...)
	if commandHandlers[command] then
		commandHandlers[command](tabName, command, ...)
	end
end)
