raceManager = RaceManager()

addEventHandler("onResourceStart", resourceRoot, function()
	-- setTimer(function()
	-- 	local testRace = Race({
	-- 		separateDimension = true,
	-- 		duration = 301
	-- 	})
	-- 	raceManager:addRace(testRace)		
	-- 	testRace:loadMap("hello-world")
	-- 	outputDebugString(tostring(testRace.map))

	-- 	for i, player in ipairs(getElementsByType("player")) do
	-- 		testRace:addPlayer(player)
	-- 	end

	-- 	setTimer(function()
	-- 		testRace:start()
	-- 	end, 3000, 1)
	-- end, 1000, 1)
end)