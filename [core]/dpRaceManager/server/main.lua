raceManager = RaceManager()

addEventHandler("onResourceStart", resourceRoot, function()
	for i, p in ipairs(getElementsByType("player")) do
		if p:getData("race_id") then
			if p.vehicle then
				p.vehicle.dimension = 0
			end			
			p.dimension = 0
		end
		p:setData("race_id", false)
	end
	-- setTimer(function()
	-- 	local testRace = Race({
	-- 		separateDimension = true,
	-- 		duration = 5
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