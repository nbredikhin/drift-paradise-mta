Drift = RaceGamemode:subclass "Drift"

function Drift:init(...)
    self.super:init(...)
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
    FinishScreen.show(true)
    toggleAllControls(false)
    triggerServerEvent("Race.clientFinished", RaceClient.raceElement)
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