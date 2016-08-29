RaceGamemode = class "RaceGamemode"

function RaceGamemode:init()

end

function RaceGamemode:addEventHandler(name, element, handler)
	if not check("RaceGamemode:addEventHandler", "name", "string", name) then return false end
	if not check("RaceGamemode:addEventHandler", "element", "element", element) then return false end
	if not check("RaceGamemode:addEventHandler", "handler", "function", handler) then return false end

	if not self.eventHandlers then
		self.eventHandlers = {}
	end
	if self.eventHandlers[name] then
		outputDebugString("RaceGamemode:addEventHandler error: Event '" .. tostring(name) .. "' is already handled")
		return false
	end
	self.eventHandlers[name] = {source = element, handler = function (...)
		handler(self, source, ...)
	end}
	addEvent(name, true)
	return addEventHandler(name, element, self.eventHandlers[name])
end

function RaceGamemode:removeEventHandlers()
	if not self.eventHandlers then
		return false
	end
	for name, eventHandler in pairs(self.eventHandlers) do
		removeEventHandler(name, eventHandler.source, eventHandler.handler)
	end
	return true
end

function RaceGamemode:raceLaunched(source)
	-- Запуск гонки. Отображение countdown'а
	Countdown.start()
end

function RaceGamemode:raceStarted(source)
	-- Начало гонки. Разморозка игроков, появление чекпойнтов
	Countdown.stop()
end

function RaceGamemode:raceFinished(source)
	-- Конец гонки
end

function RaceGamemode:playerFinished(source)
	-- Игрок финишировал
end