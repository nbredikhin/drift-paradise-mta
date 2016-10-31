Drift = RaceGamemode:subclass "Drift"

function Drift:init(...)
    self.super:init(...)
    self.forceHandling = "drift"
    self.FIRST_PLAYER_FINISHED_TIMEOUT = 10
end

function Drift:playerFinished(player)
    self.super:playerFinished(player)
end

function Drift:afterFinish()
    local players = self.race:getPlayers()
    table.sort(players, function (player1, player2)
        local score1 = player1:getData("raceDriftScore") or 0
        local score2 = player2:getData("raceDriftScore") or 0
        return score1 > score2
    end)
    for i, player in ipairs(players) do
        triggerEvent("RaceLobby.playerFinished", self.race.element, player, self:getTimePassed(), i, player:getData("raceDriftScore"))
    end
end

function Drift:raceFinished(timeout)
    local this = self
    setTimer(function ()
        this:afterFinish() 
    end, 1500, 1)
end