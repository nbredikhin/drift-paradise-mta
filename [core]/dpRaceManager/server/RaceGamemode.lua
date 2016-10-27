RaceGamemode = newclass "RaceGamemode"

local FIRST_PLAYER_FINISHED_TIMEOUT = 30

function RaceGamemode:init(race)
	self.race = race
	self.forceHandling = "street"
	self.finishedPlayers = {}
end 

function RaceGamemode:spawnPlayer(player)
	if not check("RaceGamemode:spawnPlayer", "player", "player", player) then return false end
	if not self.race then
		outputDebugString("Failed to spawn player. No race")
		return false
	end
	if not self.race.map then
		self.race:log("Failed to spawn player. No map loaded")
		return false
	end
	local spawnpoints = self.race.map.spawnpoints
	if type(spawnpoints) ~= "table" then
		self.race:log("Failed to spawn player. No spawnpoints")
		return false
	end
	local index = (#self.race:getPlayers() - 1) % #spawnpoints + 1
	local spawnpoint = spawnpoints[index]
	if type(spawnpoint) ~= "table" then
		self.race:log("Failed to spawn player. Bad spawnpoint with index " .. tostring(index))
		return false
	end

	local x, y, z, rx, ry, rz =	unpack(spawnpoint)
	player.vehicle.position = Vector3(x, y, z)
	player.vehicle.rotation = Vector3(rx, ry, rz)

	if type(self.forceHandling) == "string" then
		exports.dpVehicles:forceVehicleHandling(player.vehicle, self.forceHandling)
	end
	return true
end

function RaceGamemode:raceDestroyed()
	for _, player in ipairs(self.race:getPlayers()) do
		exports.dpVehicles:unforceVehicleHandling(player.vehicle)
	end
end

function RaceGamemode:raceStarted()
	if not self.race then
		outputDebugString("ЗАБЫЛ ВЫЗВАТЬ КОНСТРУКТОР СУКА")
	end
	for _, player in ipairs(self.race:getPlayers()) do
		player:setData("Race.finished", false)
	end 
end

function RaceGamemode:raceFinished(timeout)
	for _, player in ipairs(self.race:getPlayers()) do
		self:playerFinished(player, timeout)
	end
end

function RaceGamemode:playerRemoved(player)
	if isElement(player.vehicle) then
		exports.dpVehicles:unforceVehicleHandling(player.vehicle)
	end
end

function RaceGamemode:getTimePassed()
	if isTimer(self.race.durationTimer) then
		local timeLeft = getTimerDetails(self.race.durationTimer)
		return self.race.settings.duration * 1000 - timeLeft
	else
		return 0
	end
end

function RaceGamemode:playerFinished(player, timeout)
	if not check("RaceGamemode:playerFinished", "player", "player", player) then return false end
	-- Игрок уже финишировал
	if self.finishedPlayers[player] or player:getData("Race.finished") then
		return false
	end
	if not next(self.finishedPlayers) then
		-- Первый игрок финишировал
		self.race:log("First player finished")
		local timeLeft = self.race:getTimeLeft()
		if not timeLeft then
			timeLeft = 0
		end

		if timeLeft > FIRST_PLAYER_FINISHED_TIMEOUT then
			self.race:setTimeLeft(FIRST_PLAYER_FINISHED_TIMEOUT)
		end
	end
	self.finishedPlayers[player] = true
	player:setData("Race.finished", true)
	self.race:log("Player finished: '" .. tostring(player.name) .. "'")
	triggerClientEvent(self.race.element, "Race.playerFinished", self.race.element, player)
	return true
end