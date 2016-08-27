RaceDefault = RaceGamemode:subclass "RaceDefault"

function RaceDefault:init(...)
	self.super:init(...)
end

-- Обычные
-- Финиш - игрок доехал, вышло время
-- Победитель - первый приехавший
-- Особенности:
-- Первый игрок доехал - оставляем 15 секунд 

-- function RaceDefault:raceStarted(...)
-- 	self.super:raceStarted(...)
-- end

-- function RaceGamemode:raceFinished(...)
-- 	self.super:raceFinished(...)
-- end

-- function RaceGamemode:playerFinished(player, timeout)
-- 	if not self.super:playerFinished(player, timeout) then
-- 		return false
-- 	end
-- end



-- Дрифт
-- Финиш - доехал до финиша, время вышло
-- Победитель - по количеству очков, но неизвестен до полного завершения гонки


-- Драг
-- Финиш - игрок доехал, вышло время
-- Победитель - первый приехавший
-- Особенности:
-- Отобразить переключение скоростей на клиенте
-- Первый игрок доехал - оставляем 15 секунд 