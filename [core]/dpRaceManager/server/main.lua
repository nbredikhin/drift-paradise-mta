local function createTestRace()
	local settings = {
		gamemode = "default",
		separateDimension = true
	}
	local map = MapLoader.load("hello-world")
	map.duration = 3
	local race = Race(settings, map)
	race:addPlayer(getRandomPlayer())
	setTimer(function()
		race:launch()
	end, 2000, 1)
end

addEventHandler("onResourceStart", resourceRoot, function()
	setTimer(createTestRace, 1000, 1)

	--race:destroy()
end)