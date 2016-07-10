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
	race.raceManager = self
	race:onAdded()
	return true
end

function RaceManager:removeRace(race)
	for i, r in ipairs(self.races) do
		if r == race then
			table.remove(self.races, i)
			outputDebugString("Race removed: " .. tostring(race.id))
			return true
		end
	end
	return false
end

function RaceManager:handleEvent(eventName, source, ...)
	for i, race in ipairs(self.races) do
		if type(race[eventName]) == "function" then
			race[eventName](race, source, ...)
		end
	end
end