local function getDefaultLanguage()
	local lang = getLocalization().code
	if lang == "ru" then
		return "russian"
	else
		return "english"
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	PropsStorage.init("player_prefs.json")
	-- Настройки по умолчанию
	-- Параметры интерфейса
	PropsStorage.setDefault("ui.language", getDefaultLanguage())
	PropsStorage.setDefault("ui.theme", "red")
	PropsStorage.setDefault("ui.blur", true)
	PropsStorage.setDefault("chat.timestamp", false)
	PropsStorage.setDefault("chat.joinquit_messages", true)
	PropsStorage.setDefault("chat.block_offensive_words", true)
	-- Параметры графики
	PropsStorage.setDefault("graphics.reflections_cars", false)
	PropsStorage.setDefault("graphics.reflections_water", false)
	PropsStorage.setDefault("graphics.improved_car_lights", false)
	PropsStorage.setDefault("graphics.improved_sky", false)
	PropsStorage.setDefault("graphics.tyres_smoke", true)
	-- Параметры игры
	PropsStorage.setDefault("game.background_music", true)
	PropsStorage.save()
end)

function setProperty(key, value)
	return PropsStorage.set(key, value)
end

function getProperty(key)
	return PropsStorage.get(key)
end
