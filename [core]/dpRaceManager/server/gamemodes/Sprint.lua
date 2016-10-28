Sprint = RaceGamemode:subclass "Sprint"

function Sprint:init(...)
	self.super:init(...)
end

function Sprint:raceFinished(timeout)
	self.super:raceFinished(timeout)
	
	for i, player in ipairs(self.race:getPlayers()) do
		triggerEvent("RaceLobby.playerFinished", self.race.element, player, self:getTimePassed(), false)
	end
end

function Sprint:playerFinished(player, timeout)
    self.super:playerFinished(player, timeout)

    triggerEvent("RaceLobby.playerFinished", self.race.element, player, self:getTimePassed(), #self.finishedPlayers)
end