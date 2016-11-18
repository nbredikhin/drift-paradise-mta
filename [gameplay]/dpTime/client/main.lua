local timeForced = false

function forceTime(hh, mm)
	setTime(hh, mm)
	setMinuteDuration(60 * 1000 * 60)

	timeForced = true
end

function restoreTime()
	timeForced = false
	triggerServerEvent("dpTime.requireTime", resourceRoot)
end

addEvent("dpTime.updateTime", true)
addEventHandler("dpTime.updateTime", resourceRoot, function (time, duration)
	if timeForced then
		return 
	end
	if type(time) == "table" then
		setTime(time.hours, time.minutes)
	end
	if type(duration) == "number" then
		setMinuteDuration(duration)
	end
	setHeatHaze(0)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	restoreTime()
end)

-- Синхронизировать время каждые 5 минут
setTimer(function ()
	triggerServerEvent("dpTime.requireTime", resourceRoot)
end, 300000, 0)