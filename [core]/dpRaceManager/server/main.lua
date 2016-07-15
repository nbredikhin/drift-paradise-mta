raceManager = RaceManager()

addEventHandler("onResourceStart", resourceRoot, function()
	-- setTimer(function()
	-- 	local testRace = Race({
	-- 		noSpawnpoints = true,
	-- 		separateDimension = false
	-- 	})
	-- 	raceManager:addRace(testRace)
	-- 	testRace:addPlayer(getRandomPlayer())

	-- 	setTimer(function()
	-- 		testRace:start()
	-- 	end, 3000, 1)
	-- end, 1000, 1)
end)

addEventHandler("onVehicleStartExit", root, function(...)
	raceManager:handleEvent("onVehicleStartExit", source, ...)
end)