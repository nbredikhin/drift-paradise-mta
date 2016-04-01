Language = {}
local DEFAULT_LANGUAGE = Locales.languages[1]
local currentLanguage = DEFAULT_LANGUAGE

function Language.setLanguage(lang)
	Locales.load(lang)
	currentLanguage = lang
end

function Language.getString(name)
	local localizedString = Locales.getString(currentLanguage, name)
	if not localizedString then
		outputDebugString("Language.getString: No localized string for: " .. tostring(name))
		return false
	end
	return localizedString
end

function Language.getAllStrings(name)
	local strings = Locales.getLang(currentLanguage)
	if not strings then
		return false
	end
	return strings
end

-- Обертка над outputChatBox, отображающая сообщения в зависимости от текущего языка
function Language.chatMessage(name, ...)
	local message = Language.getString(name)
	if not message then
		outputDebugString("Language.chatMessage: No localized message for: " .. tostring(name))
		return false
	end
	return outputChatBox(message, ...)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Language.setLanguage(DEFAULT_LANGUAGE)
end)

addEvent("dpLang.chatMessageServer", true)
addEventHandler("dpLang.chatMessageServer", resourceRoot, function (name, ...)
	Language.chatMessage(name, ...)
end)