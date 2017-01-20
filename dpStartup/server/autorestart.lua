local DEFAULT_RESTART_DELAY = 60 * 30
local restartTimer


local function showRestartWarning()
    local timeLeft = getRestartTimeLeft()
    if not timeLeft then
        return
    end
    timeLeft = math.floor(timeLeft / 60)
    local t = false
    if timeLeft == 30 then
        t = 30
    elseif timeLeft == 15 then
        t = 15
    elseif timeLeft == 10 then
        t = 10
    elseif timeLeft == 5 then
        t = 5
    end
    if t then
        exports.dpChat:message(root, "global", "#FF0000* Перезапуск сервера через " .. tostring(t) .." минут")
        outputDebugString("Restart in " .. tostring(t) .. " min")
    end
end

setTimer(showRestartWarning, 60000, 0)

function getRestartTimeLeft()
    if not isTimer(restartTimer) then
        return false
    end
    local delay = getTimerDetails(restartTimer)
    if not delay then
        return false
    end
    return math.floor(delay / 1000)
end

local function doRestart()
    shutdownGamemode(true, true)
    restartResource(getThisResource())
end

function performRestart(seconds)
    if not seconds then
        seconds = DEFAULT_RESTART_DELAY
    end
    if isTimer(restartTimer) then
        cancelRestart()
    end
    restartTimer = setTimer(doRestart, (seconds + 2) * 1000, 1)
    showRestartWarning()
end

function cancelRestart()
    if isTimer(restartTimer) then
        killTimer(restartTimer)
        restartTimer = nil
        exports.dpChat:message(root, "global", "#FF0000* Перезапуск сервера отменён.")
        outputDebugString("Restart cancelled.")
    end
end