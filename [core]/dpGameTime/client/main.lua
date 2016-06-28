function forceTime(hh, mm)
	setTime(hh, mm)
	setMinuteDuration(60 * 1000 * 60)
end

function restoreTime()
	triggerServerEvent("dpGameTime.requireTime", resourceRoot)
end

addEvent("dpGameTime.updateTime", true)
addEventHandler("dpGameTime.updateTime", resourceRoot, function (time, duration)
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