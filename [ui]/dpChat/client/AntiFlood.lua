AntiFlood = {}
local FLOOD_TIME = 1000
local TEMPORARY_MUTE_TIME = 5000
local timer
local floodCount = 0

local function unmute()
	timer = nil
	floodCount = 0
end

function AntiFlood.onMessage()
	local muteTime = FLOOD_TIME
	if AntiFlood.isMuted() then
		floodCount = floodCount + 1
		if floodCount >= 3 then
			muteTime = TEMPORARY_MUTE_TIME
			floodCount = 0
		end
	end
	if isTimer(timer) then
		killTimer(timer)
	end
	timer = setTimer(unmute, muteTime, 1)
end

function AntiFlood.isMuted()
	return isTimer(timer)
end
