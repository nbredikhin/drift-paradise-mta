Language = {}
local DEFAULT_LANGUAGE = Locales.languages[1]
local FALLBACK_TO_DEFAULT = true
local currentLanguage

function Language.set(lang)
	if not lang then
		return false
	end
	if not Locales.isValid(lang) then
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

function Language.get()
	return currentLanguage
end

function Language.getLocalization()
	local language = Locales.byCode[getLocalization().code]
	if not language then
		language = DEFAULT_LANGUAGE
	end
	return language
end

function Language.getString(name)
	local localizedString = Locales.getString(currentLanguage, name)
	if not localizedString and FALLBACK_TO_DEFAULT then
		return Locales.getString(DEFAULT_LANGUAGE, name)
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

-- TODO: убрать
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
	Locales.load(DEFAULT_LANGUAGE, true)

	local language = exports.dpConfig:getProperty("ui.language")

	if not Locales.isValid(language) then
		exports.dpConfig:setProperty("ui.language", Language.getLocalization())
		return
	end

	-- Если язык не установлен в конфиге
	if not language then
		language = Language.getLocalization()
		exports.dpConfig:setProperty("ui.language", language)
	else
		Language.set(language)
	end
end)

-- TODO: убрать
addEvent("dpLang.chatMessageServer", true)
addEventHandler("dpLang.chatMessageServer", resourceRoot, function (name, ...)
	Language.chatMessage(name, ...)
end)

-- Обновление языка при изменении настроек
addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if key == "ui.language" then
		if not Language.set(value) then
			cancelEvent()
		end
	end
end)
