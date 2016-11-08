local MINUTE_DURATION = 1000
local serverTime = {
	minutes = 0,
	hours = 6,
}

setTimer(function ()
	local minutes, hours = serverTime.minutes, serverTime.hours
	minutes = minutes + 1
	if minutes >= 60 then
		minutes = 0
		hours = hours + 1
		if hours >= 24 then 
			hours = 0
		end
	end
	serverTime.minutes = minutes
	serverTime.hours = hours

end, MINUTE_DURATION, 0)

addEvent("dpTime.requireTime", true)
addEventHandler("dpTime.requireTime", resourceRoot, function ()
	triggerClientEvent(client, "dpTime.updateTime", resourceRoot, serverTime, MINUTE_DURATION)
end)

function setServerTime(hh, mm)
	if type(mm) ~= "number" or type(hh) ~= "number" then
		return false
	end
	mm = math.max(0, math.min(mm, 59))
	hh = math.max(0, math.min(hh, 23))

	serverTime.minutes = mm
	serverTime.hours = hh

	triggerClientEvent("dpTime.updateTime", resourceRoot, serverTime, MINUTE_DURATION)
	return true
end