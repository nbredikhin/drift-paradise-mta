Drift = RaceGamemode:subclass "Drift"

function Drift:init(...)
    self.super:init(...)
    self.ghostmodeEnabled = true
end

function Drift:raceStarted(...)
    self.super:raceStarted(...)
    
    DriftPoints.start()
end

function Drift:raceStopped()
    self.super:raceStopped()

    DriftPoints.stop()
end

function Drift:clientFinished()
    exports.dpDriftPoints:finishCurrentDrift()
    FinishScreen.show(true)
    toggleAllControls(false)
    setTimer(function ()
        triggerServerEvent("Race.clientFinished", RaceClient.raceElement)
    end, 100, 1)
end

function Drift:raceFinished(...)
    self.super:raceFinished(...)
    exports.dpDriftPoints:finishCurrentDrift()
end

function Drift:updatePosition()
    local players = RaceClient.getPlayers()
    if type(players) ~= "table" then
        return false
    end
    local myScore = localPlayer:getData("raceDriftScore")
    local rank = 1
    for i, player in ipairs(players) do
        if player ~= localPlayer then
            local playerScore = player:getData("raceDriftScore")
            if playerScore and playerScore > myScore then
                rank = rank + 1
            end
        end
    end

    self.rank = rank
end