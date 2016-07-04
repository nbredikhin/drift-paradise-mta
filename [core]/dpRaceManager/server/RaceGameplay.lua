--- Класс геймпеля гонки
-- @module dpRaceManager.RaceGameplay
-- @author Wherry

RaceGameplay = newclass("RaceGameplay")

function RaceGameplay:init(race)
	self.race = race
end

function RaceGameplay:onPlayerJoin(player)
	if player.vehicle then
		player:removeFromVehicle()
	end
	player:fadeCamera(false, 0.5)
	-- Машина для гонки	
	local vehicle = Vehicle(411, player.position + Vector3(0, 2, 0))
	vehicle.dimension = self.race.dimension
	vehicle.frozen = true

	setTimer(function()
		if not isElement(player) then
			return
		end	
		-- Перемещение игрока в гонку
		player.dimension = self.race.dimension
		player:warpIntoVehicle(vehicle)
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