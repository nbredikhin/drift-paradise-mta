addEventHandler("onResourceStart", resourceRoot, function()
	local settings = {
		gamemode = "default",
		separateDimension = true
	}
	local map = MapLoader.load("hello-world")
	map.duration = 5
	local race = Race(settings, map)
	race:addPlayer(getRandomPlayer())
	setTimer(function()
		race:launch()
	end, 2000, 1)

	--race:destroy()
end)