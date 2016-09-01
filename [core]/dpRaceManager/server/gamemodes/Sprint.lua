Sprint = RaceGamemode:subclass "Sprint"

function Sprint:init(...)
	self.super:init(...)
end

-- Обычные
-- Финиш - игрок доехал, вышло время
-- Победитель - первый приехавший
-- Особенности:
-- Первый игрок доехал - оставляем 15 секунд 

-- function Sprint:raceStarted(...)
-- 	self.super:raceStarted(...)
-- end

function Sprint:raceFinished(timeout)
	self.super:raceFinished(timeout)
	
	if timeout then
		self.race:removePlayer(getRandomPlayer())
	end
end

-- function RaceDefault:playerFinished(player, timeout)
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