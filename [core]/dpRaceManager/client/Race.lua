Race = {}
Race.state = nil
Race.settings = {}
Race.players = {}
Race.rank = 0

local finishedPlayers = {}
local raceObjects = {}
Race.dimension = 0

local isActive = false
local rpcMethods = {}
local finishScreen
local isFinished = false

local rankTimer

local function calculateRank()
	if isFinished then
		return
	end
	if not Race.players or #Race.players == 0 then
		Race.rank = 0
		return
	end
	if #Race.players == 1 then
		Race.rank = 1
		return
	end

	if Race.settings.gamemode == "drift" then
		local rank = 1
		for i, p in ipairs(Race.players) do
			local playerScore = p:getData("raceDriftScore")
			if type(playerScore) == "number" and playerScore > DriftPoints.getScore() then
				rank = rank + 1
			end
		end
		Race.rank = rank
	else
		local localCheckpoint = RaceCheckpoints.getCurrentCheckpoint()
		local distance = getDistanceBetweenPoints2D(localPlayer.vehicle.position, RaceCheckpoints.getCheckpointPosition())
		local rank = 1
		for i, p in ipairs(Race.players) do
			local playerCheckpoint = p:getData("race_checkpoint")
			if playerCheckpoint > localCheckpoint then
				rank = rank + 1
			elseif playerCheckpoint == localCheckpoint then
				local pos = RaceCheckpoints.getCheckpointPosition()
				if pos and getDistanceBetweenPoints2D(p.vehicle.position, pos) < distance then
					rank = rank + 1
				end
			end
		end
		Race.rank = rank
	end
end

local function onKey(key, state)
	if not state then
		return
	end
	if key == "F1" then
		if QuitPrompt.isVisible() or isFinished then
			QuitPrompt.hide()
		else
			QuitPrompt.show()
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	if localPlayer:getData("dpCore.state") == "race" then
		localPlayer:setData("dpCore.state", false)
		localPlayer:setData("activeUI", false)		
	end
end)

function Race.start()
	if isActive then
		return false
	end
	localPlayer:setData("dpCore.state", "race")
	localPlayer:setData("activeUI", "raceUI")
	isActive = true
	Race.state = nil
	isFinished = false
	finishScreen = nil
	RaceUI.start()	
	finishedPlayers = {}
	Race.players = {}
	toggleControl("enter_exit", false)

	rankTimer = setTimer(calculateRank, 1000, 0)
	addEventHandler("onClientKey", root, onKey)

	if Race.settings.gamemode == "drift" then
		localPlayer:setData("raceDriftScore", 0)
		DriftPoints.start()
	end
end

function Race.stop()
	if not isActive then
		return false
	end
	DriftPoints.stop()
	localPlayer:setData("dpCore.state", false)
	localPlayer:setData("activeUI", false)	
	isActive = false
	Race.state = nil
	RaceUI.stop()

	for i, object in ipairs(raceObjects) do
		if isElement(object) then
			destroyElement(object)
		end
	end
	raceObjects = {}
	triggerServerEvent("leaveRace", resourceRoot)
	RaceCheckpoints.stop()
	toggleControl("enter_exit", true)

	if isTimer(rankTimer) then
		killTimer(rankTimer)
		rankTimer = nil
	end		
	removeEventHandler("onClientKey", root, onKey)
end

function Race.finished(timeout)
	DriftPoints.stop()
	QuitPrompt.hide()
	RaceCheckpoints.stop()
	Countdown.stop()
	triggerServerEvent("finishRace", resourceRoot)
	isFinished = true
	finishScreen = FinishScreen()
	RaceUI.screenManager:showScreen(finishScreen)
end

function Race.getFinishedPlayers()
	return finishedPlayers
end

-- RPC
function Race.addMethod(name, callback)
	if type(name) ~= "string" or type(callback) ~= "function" then
		return false
	end
	rpcMethods[name] = callback
	return true
end

addEvent("dpRaceManager.rpc", true)
addEventHandler("dpRaceManager.rpc", resourceRoot, function (name, ...)
	if type(name) ~= "string" then
		return
	end
	if type(rpcMethods[name]) ~= "function" then
		return
	end
	rpcMethods[name](...)
end)

-- Локальный игрок присоединился к гонке
Race.addMethod("onJoin", function (settings, dimension)
	Race.settings = settings
	Race.dimension = dimension
	if not Race.dimension then 
		Race.dimension = 0
	end
	Race.start()
end)

Race.addMethod("onPlayerLeave", function (player)
	if Race.players then
		for i, p in ipairs(Race.players) do
			if p == player then
				table.remove(Race.players, i)
				break
			end
		end
	end
end)

-- Локальный игрок покинул гонку
Race.addMethod("onLeave", function ()
	Race.stop()
end)

Race.addMethod("timeout", function ()
	Race.finished(true)
end)

Race.addMethod("removed", function ()
	Race.stop()
end)

Race.addMethod("finished", function ()
	Race.finished()
	outputDebugString("RACE FINISHED")
end)

-- Изменилось состоние гонки
Race.addMethod("updateState", function (state)
	Race.state = state
	RaceUI.setState(state)
end)

-- Сервер отправил карту
Race.addMethod("loadMap", function (mapJSON)
	local map = fromJSON(mapJSON)

	if type(map.objects) == "table" then
		for i, o in ipairs(map.objects) do
			local object = createObject(unpack(o))
			object.dimension = Race.dimension
			table.insert(raceObjects, object)
		end
	end	
	if type(map.checkpoints) == "table" then
		RaceCheckpoints.start(map.checkpoints)
	end
end)

Race.addMethod("showCountdown", function(players)
	RaceUI.showCountdown()	
	Race.players = players
end)

Race.addMethod("updateFinishedPlayers", function (players)
	finishedPlayers = players
	if type(finishedPlayers) == "table" then
		table.sort(finishedPlayers, function (a, b)
			return a.rank < b.rank
		end)
	end
	if finishScreen then
		finishScreen:setPlayersList(players)
	end
end)