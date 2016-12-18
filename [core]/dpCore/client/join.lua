addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Отключение размытия при движении
	setBlurLevel(0)
	-- Отключение скрытия объектов
	setOcclusionsEnabled(false)
	-- Отключение фоновых звуков стрельбы
	setWorldSoundEnabled(5, false)

	setWeather(0)
	setTime(12, 0)
	setMinuteDuration(60000 * 60 * 24)
end)
