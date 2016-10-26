Duel = RaceGamemode:subclass "Duel"

-- Дуэль
-- Финиш - один игрок доехал
-- Победитель - первый приехавший
-- Особенности:
-- Первый игрок доехал - оставляем 15 секунд

function Duel:init(...)
	self.super:init(...)
end

function Duel:raceFinished(timeout)
	self.super:raceFinished(timeout)
	
	if timeout then
		triggerEvent("RaceDuel.finished", self.race.element)
	end
	self.race:destroy()
end

function Duel:getTimePassed()
	if isTimer(self.race.durationTimer) then
		local timeLeft = getTimerDetails(self.race.durationTimer)
		return self.race.settings.duration * 1000 - timeLeft
	else
		return 0
	end
end

function Duel:playerRemoved(player)
	self.super:playerRemoved(player)
	local players = self.race:getPlayers()
	if #players > 0 then
		triggerEvent("RaceDuel.finished", self.race.element, players[1], self:getTimePassed())
	end
	self.race:destroy()
end

function Duel:playerFinished(player)
	triggerEvent("RaceDuel.finished", self.race.element, player, self:getTimePassed())
	self.race:destroy()
end