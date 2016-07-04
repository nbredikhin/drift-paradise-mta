addEventHandler("onResourceStart", resourceRoot, function()
	local raceManager = RaceManager()
	outputDebugString("RaceManager started: " .. tostring(raceManager:class():name()))

	local testRace = Race()
	raceManager:addRace(testRace)
	testRace:addPlayer(getRandomPlayer())
end)