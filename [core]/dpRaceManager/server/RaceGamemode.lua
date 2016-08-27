RaceGamemode = newclass "RaceGamemode"

function RaceGamemode:init(race)
	self.race = race
	self.finishedPlayers = {}
end 

function RaceGamemode:spawnPlayer(player)
	if not check("RaceGamemode:spawnPlayer", "player", "player", player) then return false end
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
	return true
end

function RaceGamemode:raceStarted()
	for _, player in ipairs(self.race:getPlayers()) do
		player:setData("Race.finished", false)
	end 
end

function RaceGamemode:raceFinished(timeout)
	for _, player in ipairs(self.race:getPlayers()) do
		self:playerFinished(player, timeout)
	end
end

function RaceGamemode:playerFinished(player, timeout)
	if not check("RaceGamemode:playerFinished", "player", "player", player) then return false end
	-- Игрок уже финишировал
	if self.finishedPlayers[player] or player:getData("Race.finished") then
		return false
	end
	self.finishedPlayers[player] = true
	player:setData("Race.finished", true)
	self.race:log("Player finished: '" .. tostring(player.name) .. "'")
	return true
end