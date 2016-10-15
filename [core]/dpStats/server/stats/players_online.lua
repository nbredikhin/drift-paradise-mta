StatsManager.registerSource("players_online", getMillisecondsFromHours(0.5), 48, function ()
    return #getElementsByType("player")
end)