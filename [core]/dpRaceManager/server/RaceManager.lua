RaceManager = newclass("RaceManager")

function RaceManager:init()
	self.races = {}
end

function RaceManager:addRace(race)
	if type(race) ~= "table" or not race:class() or race:class():name() ~= "Race" then
		outputDebugString("RaceManager: Bad argument #1 for 'addRace'. Expected 'Race', got '" .. tostring(race) .. "'")
		return false
	end
	table.insert(self.races, race)
	race.id = #self.races
	return true
end

function RaceManager:removeRace(race)
	for i, r in ipairs(self.races) do
		if r == race then
			table.remove(self.races, i)
			return true
		end
	end
	return false
end