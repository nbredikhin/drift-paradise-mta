RaceManager = newclass("RaceManager")

function RaceManager:init()
	self.races = {}
end

function RaceManager:addRace(race)
	if type(race) ~= "table" or not race:class() or race:class():name() ~= "Race" then
		outputDebugString("RaceManager: Bad argument #1 for 'addRace'. Expected 'Race', got '" .. tostring(race) .. "'")
		return false
	end
	local added = false
	for i = 1, #self.races do
		if not self.races[i] then
			self.races[i] = race
			race.id = i
			added = true
		end 
	end
	if not added then
		table.insert(self.races, race)
		race.id = #self.races
	end	
	race.raceManager = self
	race:onAdded()
	return race.id
end

function RaceManager:getRaceById(id)
	if type(id) ~= "number" then
		return false
	end
	for i, race in ipairs(self.races) do
		if race.id == id then
			return race
		end
	end
	return false
end

function RaceManager:removeRace(race)
	for i, r in ipairs(self.races) do
		if r == race then
			self.races[i] = nil
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