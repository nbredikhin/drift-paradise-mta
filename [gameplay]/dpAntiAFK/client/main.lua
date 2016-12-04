local AFK_TIMEOUT = 10
local afkTimer

local function reportAFK()
	if not localPlayer:getData("_id") then
		return
	end

	triggerServerEvent("selfKick", localPlayer, "afk")	
end

local function resetTimer()
	if isTimer(afkTimer) then
		killTimer(afkTimer)
	end

	afkTimer = setTimer(reportAFK, 1000 * 60 * AFK_TIMEOUT, 1)
end

addEventHandler("onClientMouseMove", root, resetTimer)
addEventHandler("onClientKey", root, resetTimer)
addEventHandler("onClientClick", root, resetTimer)