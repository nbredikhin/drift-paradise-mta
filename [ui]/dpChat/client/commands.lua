local commandHandlers = {}

commandHandlers["cleardebug"] = function ()
	for i = 1, 25 do 
		local text = " "
		for j = 1, i do
			text = text .. " "
		end
		outputDebugString(text) 
	end
end

addEvent("dpChat.command")
addEventHandler("dpChat.command", root, function(tabName, command, ...)
	if commandHandlers[command] then
		commandHandlers[command](...)
	end
end)
