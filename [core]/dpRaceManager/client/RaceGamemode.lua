RaceGamemode = newclass "RaceGamemode"

function RaceGamemode:init()
	self.rank = 0
end

function RaceGamemode:checkpointHit(checkpointId)
	localPlayer:setData("Race.currentCheckpoint", checkpointId, true)
end

function RaceGamemode:updatePosition()
	local players = RaceClient.getPlayers()
	if type(players) ~= "table" then
		return false
	end
	local currentCheckpoint = RaceCheckpoints.getCurrentCheckpoint()
	local checkpointPosition = RaceCheckpoints.getCheckpointPosition()
	local myDistance = (checkpointPosition - localPlayer.position):getLength()

	local rank = 1
	for i, player in ipairs(players) do
		if player ~= localPlayer then
			local playerCheckpoint = player:getData("Race.currentCheckpoint")
			if type(playerCheckpoint) == "number" then
				if playerCheckpoint > currentCheckpoint then
					rank = rank + 1
				elseif currentCheckpoint == playerCheckpoint then
					local distance = (checkpointPosition - player.position):getLength()
					if distance < myDistance then
						rank = rank + 1
					end
				end
			end
		end
	end

	self.rank = rank
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
	-- Сбросить текущий чекпойнт
	localPlayer:setData("Race.currentCheckpoint", RaceCheckpoints.getCurrentCheckpoint(), true)
	-- Запустить GUI таймера
	RaceTimer.start()
end

function RaceGamemode:raceFinished(source)
	-- Конец гонки
end

function RaceGamemode:playerFinished(raceElement, player)
	-- Игрок финишировал
	if player == localPlayer then		
		-- 
	end
end

function RaceGamemode:clientFinished()
	toggleAllControls(false)
	triggerServerEvent("Race.clientFinished", RaceClient.raceElement)
end