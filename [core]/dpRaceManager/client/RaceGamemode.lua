RaceGamemode = newclass "RaceGamemode"

function RaceGamemode:init()
	self.rank = 0
	self.ghostmodeEnabled = false
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

function RaceGamemode:raceStarted()	
	-- Начало гонки. Разморозка игроков, появление чекпойнтов
	-- Сбросить текущий чекпойнт
	localPlayer:setData("Race.currentCheckpoint", RaceCheckpoints.getCurrentCheckpoint(), true)
	-- Запустить GUI таймера
	toggleAllControls(true)
	RaceTimer.start()

	-- Отключить коллизии
	exports.dpSafeZones:leaveSafeZones()
	if self.ghostmodeEnabled and localPlayer.vehicle then
		outputDebugString("Turn ghostmode on")
		for i, player1 in ipairs(RaceClient.getPlayers()) do
			for j, player2 in ipairs(RaceClient.getPlayers()) do
				if player1 ~= player2 then
					player1.vehicle:setCollidableWith(player2.vehicle, false)
				end
			end
		end
		setCameraClip(true, false)		
	end	
end

function RaceGamemode:raceStopped()
	if self.ghostmodeEnabled and isElement(localPlayer.vehicle) then
		outputDebugString("Turn ghostmode off")
		for i, vehicle1 in ipairs(getElementsByType("vehicle")) do
			for j, vehicle2 in ipairs(getElementsByType("vehicle")) do
				vehicle1:setCollidableWith(vehicle2, true)
			end
		end
		setCameraClip(true, true)		
	end	
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
	FinishScreen.show(false)
	toggleAllControls(false)
	setControlState("handbrake", true)
	triggerServerEvent("Race.clientFinished", RaceClient.raceElement)
end