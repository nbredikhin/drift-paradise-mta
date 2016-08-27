addEventHandler("onResourceStart", resourceRoot, function()
	local settings = {
		gamemode = "default",
		separateDimension = true
	}
	local race = Race(settings, MapLoader.load("hello-world.map"))
	race:addPlayer(getRandomPlayer())

	--race:destroy()
end)