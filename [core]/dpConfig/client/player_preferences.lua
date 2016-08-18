addEventHandler("onClientResourceStart", resourceRoot, function ()
	PropsStorage.init("player_prefs.json")
	-- Настройки по умолчанию
	-- Параметры интерфейса
	PropsStorage.setDefault("ui.language", "english")
	PropsStorage.setDefault("ui.theme", "red")
	PropsStorage.setDefault("ui.blur", true)
	PropsStorage.setDefault("chat.timestamp", false)
	-- Параметры графики
	PropsStorage.setDefault("graphics.reflections_cars", false)
	PropsStorage.setDefault("graphics.reflections_water", false)
	PropsStorage.setDefault("graphics.improved_car_lights", false)
	PropsStorage.setDefault("graphics.improved_sky", false)
	PropsStorage.setDefault("graphics.tyres_smoke", true)
	PropsStorage.save()
end)

function setProperty(key, value)
	return PropsStorage.set(key, value)
end

function getProperty(key)
	return PropsStorage.get(key)
end
