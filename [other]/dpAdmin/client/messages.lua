addEvent("dpAdmin.showMessage", true)
addEventHandler("dpAdmin.showMessage", resourceRoot, function (message, admin, player, duration)
	if message == "mute" then
		local messageText = string.format(
			exports.dpLang:getString("chat_admin_mute"), 
			exports.dpUtils:removeHexFromString(player.name), 
			exports.dpUtils:removeHexFromString(admin.name), 
			tostring(duration))
		exports.dpChat:message("global", messageText, 255, 0, 0)
	elseif message == "ban" then
		local messageText = string.format(
			exports.dpLang:getString("chat_admin_ban"), 
			exports.dpUtils:removeHexFromString(player.name), 
			exports.dpUtils:removeHexFromString(admin.name))
		exports.dpChat:message("global", messageText, 255, 0, 0)
	elseif message == "unmute" then
		local messageText = string.format(
			exports.dpLang:getString("chat_admin_unmute"), 
			exports.dpUtils:removeHexFromString(player.name), 
			exports.dpUtils:removeHexFromString(admin.name))
		exports.dpChat:message("global", messageText, 0, 255, 0)		
	end
end)