--- Класс геймпеля гонки
-- @module dpRaceManager.RaceGameplay
-- @author Wherry

RaceGameplay = newclass("RaceGameplay")

function RaceGameplay:init(race)
	self.race = race
end

function RaceGameplay:onPlayerJoin(player)
	-- Машина для гонки	
	local vehicle
	if self.race.settings.createVehicles then
		player:removeFromVehicle()
		vehicle = Vehicle(411, player.position + Vector3(0, 2, 0))
	else
		vehicle = player.vehicle
		if not isElement(vehicle) then
			return
		end
	end
	if not self.race.settings.noDimension then
		vehicle.dimension = self.race.dimension
	end
	vehicle.frozen = true
	player:fadeCamera(false, 0.5)
	local race = self.race
	setTimer(function()
		if not isElement(player) then
			return
		end	
		-- Перемещение игрока в гонку
		if not race.settings.noSpawnpoints then
			-- TODO: Переместить игрока на точку спавна
		end
		if not race.settings.noDimension then
			player.dimension = race.dimension
		end
		if not player.vehicle then
			player:warpIntoVehicle(vehicle)
		end
		player:fadeCamera(true)
		player:setCameraTarget(player)
	end, 1000, 1)
end

function RaceGameplay:onPlayerLeave(player)
	if player.vehicle then
		player.vehicle.dimension = 0
		-- Разморозить машину
		if player.vehicle.frozen then
			player.vehicle.frozen = false
		end
	end
	outputDebugString("Leave")
	player.dimension = 0
end

function RaceGameplay:onRaceStart()
	for i, player in ipairs(self.race.players) do
		player.vehicle.frozen = false
	end
end