local MINUTE_DURATION = 60000
local serverTime = {
	minutes = 0,
	hours = 6,
}

setTimer(function ()
	local minutes, hours = serverTime.minutes, serverTime.hours
	minutes = minutes + 1
	if minutes > 60 then
		minutes = 0
		hours = hours + 1
		if hours > 24 then 
			hours = 0
		end
	end
	serverTime.minutes = minutes
	serverTime.hours = hours

end, MINUTE_DURATION, 0)

addEvent("dpGameTime.requireTime", true)
addEventHandler("dpGameTime.requireTime", resourceRoot, function ()
	triggerClientEvent(client, "dpGameTime.updateTime", resourceRoot, serverTime, MINUTE_DURATION)
end)