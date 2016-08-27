RaceDefault = RaceGamemode:subclass "RaceDefault"

-- Дуэль
-- Финиш - один игрок доехал
-- Победитель - первый приехавший
-- Особенности:
-- Первый игрок доехал - оставляем 15 секунд 

function RaceDefault:raceStarted()
	self.super:raceStarted()
end

function RaceGamemode:raceFinished()
	self.super:raceFinished()
end

function RaceGamemode:playerFinished(player, timeout)
	self.super