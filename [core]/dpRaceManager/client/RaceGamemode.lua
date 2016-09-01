RaceGamemode = newclass "RaceGamemode"

function RaceGamemode:init()

end

function RaceGamemode:addEventHandler(name, source, handler)
	if not check("RaceGamemode:addEventHandler", "name", "string", name) then return false end
	if not check("RaceGamemode:addEventHandler", "source", "element", source) then return false end
	if not check("RaceGamemode:addEventHandler", "handler", "function", handler) then return false end

	if not self.eventHandlers then
		self.eventHandlers = {}
	end
	if self.eventHandlers[name] then
		outputDebugString("RaceGamemode:addEventHandler error: Event '" .. tostring(name) .. "' is already handled")
		return false
	end
	self.eventHandlers[name] = source
	addEvent(name, true)
	return addEventHandler(name, source, function (...)
		handler(self, source, ...)
	end)
end

-- Удаляет все добавленные event handler'ы 
function RaceGamemode:removeEventHandlers()
	if not self.eventHandlers then
		return false
	end
	for name, source in pairs(self.eventHandlers) do
		if isElement(source) then
			local handlers = getEventHandlers(name, source)
			for i, handler in ipairs(handlers) do
				removeEventHandler(name, source, handler)
			end
		end
	end
	return true
end

function RaceGamemode:playerAdded(source)
	-- Другой игрок добавлен в гонку
end

function RaceGamemode:playerRemoved(source)
	-- Другой игрок удален из гонки
end

function RaceGamemode:raceLaunched(source)
	-- Запуск гонки. Отображение countdown'а
	Countdown.start()
end

function RaceGamemode:raceStarted(source)
	-- Начало гонки. Разморозка игроков, появление чекпойнтов
	RaceTimer.start()
end

function RaceGamemode:raceFinished(source)
	-- Конец гонки
end

function RaceGamemode:playerFinished(source)
	-- Игрок финишировал
	if source == localPlayer then
		-- Если финишировал клиент - скрыть таймер и отобразить таблицу
		RaceTimer.stop()
	end
end

function RaceGamemode:clientFinished()
	triggerServerEvent("Race.clientFinished", RaceClient.raceElement)
end