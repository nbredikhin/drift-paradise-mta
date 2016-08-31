RaceDuel = RaceGamemode:subclass "RaceDuel"

-- Дуэль
-- Финиш - один игрок доехал
-- Победитель - первый приехавший
-- Особенности:
-- Первый игрок доехал - оставляем 15 секунд

function RaceDuel:init(...)
	self.super:init(...)
end

function RaceDuel:raceFinished(timeout)
	self.super:raceFinished(timeout)
	
	if timeout then
		for i, player in ipairs(self.race:getPlayers()) do
			self.race:removePlayer(player)
		end
	end
end