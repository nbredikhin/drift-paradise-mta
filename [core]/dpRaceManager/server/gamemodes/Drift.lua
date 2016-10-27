Drift = RaceGamemode:subclass "Drift"

function Drift:init(...)
    self.super:init(...)
end

function Drift:playerFinished(player)
    self.super:playerFinished(player)
end

function Drift:raceFinished(timeout)
    for i, player in ipairs(self.race:getPlayers()) do
        triggerEvent("RaceLobby.playerFinished", self.race.element, player, self:getTimePassed())
    end
end