Sprint = RaceGamemode:subclass "Sprint"

function Sprint:init(...)
	self.super:init(...)
end

function Sprint:raceFinished(timeout)
	self.super:raceFinished(timeout)
	
	if timeout then
		triggerEvent("RaceLobby.playerFinished", self.race.element, player)
	end
end

function Sprint:playerFinished(player, timeout)
    self.super:playerFinished(player, timeout)

    triggerEvent("RaceLobby.playerFinished", self.race.element, player, self:getTimePassed())
end