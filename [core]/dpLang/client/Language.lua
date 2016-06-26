Language = {}
local DEFAULT_LANGUAGE = Locales.languages[1]
local currentLanguage = DEFAULT_LANGUAGE

function Language.setLanguage(lang)
	if not lang then
		return false
	end
	if currentLanguage then
		Locales.unload(currentLanguage)
	end
	Locales.load(lang)
	currentLanguage = lang
	triggerEvent("dpLang.languageChanged", root, currentLanguage)
	return true
end

function Language.getLanguage()
	return currentLanguage
end

function Language.getString(name)
	local localizedString = Locales.getString(currentLanguage, name)
	if not localizedString then
		outputDebugString("Language.getString: No localized string for: " .. tostring(name))
		return false
	end
	return localizedString
end

function Language.getAllStrings()
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
	-- Ставим язык из настроек
	if not Language.setLanguage(exports.dpConfig:getProperty("ui.language")) then
		-- Если не удалось поставить язык из настроек, ставим дефолтный
		Language.setLanguage(DEFAULT_LANGUAGE)
	end
end)

addEvent("dpLang.chatMessageServer", true)
addEventHandler("dpLang.chatMessageServer", resourceRoot, function (name, ...)
	Language.chatMessage(name, ...)
end)

-- Обновление языка при изменении настроек
addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if key == "ui.language" then
		Language.setLanguage(value)
	end
end)