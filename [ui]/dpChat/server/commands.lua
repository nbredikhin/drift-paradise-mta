local commandHandlers = {}

commandHandlers["start"] = function (player, resourceName)
	if type(resourceName) ~= "string" then
		outputDebugString("Bad resource name '" .. tostring(resourceName) .. "'")
		return
	end
	if hasObjectPermissionTo(player, "command.start", false) then
		local resource = getResourceFromName(resourceName)
		if not resource then
			outputDebugString("Resource not found '" .. tostring(resourceName) .. "'")
			return
		end
		resource:start()
	end
end

commandHandlers["stop"] = function (player, resourceName)
	if type(resourceName) ~= "string" then
		return
	end
	if hasObjectPermissionTo(player, "command.stop", false) then
		local resource = getResourceFromName(resourceName)
		if not resource then
			return
		end
		resource:stop()
	end
end

commandHandlers["restart"] = function (player, resourceName)
	if type(resourceName) ~= "string" then
		return
	end
	if hasObjectPermissionTo(player, "command.restart", false) then
		local resource = getResourceFromName(resourceName)
		if not resource then
			return
		end
		resource:restart()
	end
end

addEvent("dpChat.command", true)
addEventHandler("dpChat.command", root, function(tabName, command, ...)
	if commandHandlers[command] then
		commandHandlers[command](client, ...)
	end
end)
