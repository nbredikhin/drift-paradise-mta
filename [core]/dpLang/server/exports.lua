function chatMessage(name, player, ...)
	local args = {...}
	local success = pcall(function ()
		triggerClientEvent(player, "dpLang.chatMessageServer", resourceRoot, name, unpack(args))
	end)
	return success
end