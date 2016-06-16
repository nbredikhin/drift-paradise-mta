local function onPlayerConnect()
	local messageColor = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())
	local playerName = exports.dpUtils:removeHexFromString(source.name)
	outputChatBox(
		messageColor .. string.format(exports.dpLang:getString("chat_message_player_join"), playerName), 
		255, 255, 255,
		true
	)
end

local function onPlayerQuit(reason)
	source = localPlayer
	local messageColor = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())
	local playerName = exports.dpUtils:removeHexFromString(source.name)
	reason = exports.dpLang:getString("quit_reason_" .. string.lower(tostring(reason)))
	outputChatBox(
		messageColor .. string.format(exports.dpLang:getString("chat_message_player_quit"), playerName, reason), 
		255, 255, 255,
		true
	)
end

onPlayerQuit("Banned")

addEventHandler("onClientPlayerJoin", getRootElement(), onPlayerConnect)
addEventHandler("onClientPlayerQuit", getRootElement(), onPlayerQuit)