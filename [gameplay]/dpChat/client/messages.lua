local messageHandlers = {}
messageHandlers["adminsay"] = function (player, message)
	local messageColor = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())
	local playerName = exports.dpUtils:removeHexFromString(player.name)
	local adminStr = exports.dpLang:getString("chat_adminsay_admin")
	outputChatBox(messageColor .. "[" .. adminStr .. "] " .. playerName .. ": #FFFFFF" .. tostring(message), 255, 255, 255, true)
end

addEvent("dpChat.message", true)
addEventHandler("dpChat.message", resourceRoot, function (messageType, player, message)
	if messageHandlers[messageType] then
		messageHandlers[messageType](player, message)
	end
end)