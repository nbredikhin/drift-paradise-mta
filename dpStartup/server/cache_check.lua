local cacheCheckEnabled = false

addEvent("dpCacheLock.reportMissingCache", true)
addEventHandler("dpCacheLock.reportMissingCache", resourceRoot, function ()
	if not cacheCheckEnabled then
		return
	else
		outputDebugString("Player joined without cache: " .. tostring(client.name))
		kickPlayer(client, "Download cache here: vk.com/driftparadise")
	end
end)

addEvent("dpChat.command", true)
addEventHandler("dpChat.command", root, function (tab, command, ...)
	if command ~= "forcecache" then
		return
	end
	if not exports.dpUtils:isPlayerAdmin(client) then
		return 
	end

	cacheCheckEnabled = not cacheCheckEnabled
	exports.dpChat:message(client, "global", "Cache check: " .. tostring(cacheCheckEnabled))
end)