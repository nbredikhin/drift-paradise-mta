RaceGamemode = newclass "RaceGamemode"

function RaceGamemode:init(race)
	self.race = race
	self.finishedPlayers = {}
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
	-- Игрок уже финишировал
	if self.finishedPlayers[player] or player:getData("Race.finished") then
		return false
	end
	self.finishedPlayers[player] = true
	player:setData("Race.finished", true)
	self.race:log("Player finished: '" .. tostring(player.name) .. "'")
	return true
end