--- Класс геймпеля гонки
-- @module dpRaceManager.RaceGameplay
-- @author Wherry

RaceGameplay = newclass("RaceGameplay")

function RaceGameplay:init(race)
	self.race = race

	self.currentSpawnpoint = 1
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
	vehicle.frozen = true
	if self.race.settings.fadeCameraOnJoin then
		player:fadeCamera(false, 0.5)
	end	
	local race = self.race
	setTimer(function()
		if not isElement(player) then
			return
		end	
		-- Перемещение игрока в гонку
		if self.race.settings.separateDimension then
			vehicle.dimension = self.race.dimension
			player.dimension = race.dimension
		end
		vehicle.frozen = true
		if not race.settings.ignoreSpawnpoints then
			local spawnpoints = self.race.map.spawnpoints
			if type(spawnpoints) == "table" and #spawnpoints > 0 then
				local x, y, z, rx, ry, rz = unpack(spawnpoints[self.currentSpawnpoint])

				vehicle.position = Vector3(x, y, z)
				vehicle.rotation = Vector3(rx, ry, rz)

				self.currentSpawnpoint = self.currentSpawnpoint + 1
				if self.currentSpawnpoint > #spawnpoints then
					self.currentSpawnpoint = 1
				end
			end
		end
		if not player.vehicle then
			player:warpIntoVehicle(vehicle)
		end

		if race.settings.fadeCameraOnJoin then
			player:fadeCamera(true)
			player:setCameraTarget(player)
		end				
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
	player.dimension = 0
end

function RaceGameplay:onRaceStart()
	for i, player in ipairs(self.race.players) do
		player.vehicle.frozen = false
	end
end