local raceManager

addEventHandler("onResourceStart", resourceRoot, function()
	raceManager = RaceManager()
	outputDebugString("RaceManager started: " .. tostring(raceManager:class():name()))

	local testRace = Race()
	raceManager:addRace(testRace)
	testRace:addPlayer(getRandomPlayer())

	setTimer(function()
		testRace:start()
	end, 3000, 1)
end)

addEventHandler("onVehicleStartExit", root, function(...)
	raceManager:handleEvent("onVehicleStartExit", source, ...)
end)