addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Отключение размытия при движении
	setBlurLevel(0)
	-- Отключение скрытия объектов
	setOcclusionsEnabled(false)

	setWeather(0)
	setTime(12, 0)
	setMinuteDuration(60000 * 60 * 24)
end)

addEventHandler("onClientPlayerSpawn", localPlayer, function ()
	exports.dpHUD:showAll()
end)