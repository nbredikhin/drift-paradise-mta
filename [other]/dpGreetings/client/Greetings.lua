local function onPlayerConnect()
	if exports.dpConfig:getProperty("chat.joinquit_messages") then
		local messageColor = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())
		local playerName = exports.dpUtils:removeHexFromString(source.name)
		exports.dpChat:message(
			"global",
			messageColor .. string.format(exports.dpLang:getString("chat_message_player_join"), playerName),
			255, 255, 255
		)
	end
end

local function onPlayerQuit(reason)
	if exports.dpConfig:getProperty("chat.joinquit_messages") then
		local messageColor = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())
		local playerName = exports.dpUtils:removeHexFromString(source.name)
		reason = exports.dpLang:getString("quit_reason_" .. string.lower(tostring(reason)))
		exports.dpChat:message(
			"global",
			messageColor .. string.format(exports.dpLang:getString("chat_message_player_quit"), playerName, reason),
			255, 255, 255
		)
	end
end

addEventHandler("onClientPlayerJoin", getRootElement(), onPlayerConnect)
addEventHandler("onClientPlayerQuit", getRootElement(), onPlayerQuit)
