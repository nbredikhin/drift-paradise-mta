-- Обёртка для безопасного вызова функции
local function safeCall(fn, ...)
	local result = {pcall(fn, ...)}
	if result[1] then
		return select(2, unpack(result))
	else
		outputDebugString("Race call error: " .. tostring(result[2]))
		return false
	end
end

local function exportRaceFunction(exportedName, functionName)
	_G[exportedName] = function(raceElement, ...)
		local race = getRaceByElement(raceElement)
		if race then
			return safeCall(function(...)
				return race[functionName](race, ...)
			end, ...)
		else
			return false
		end
	end
end

-- Race:init
function createRace(...)	
	return safeCall(function(...)
		local race = Race(...)
		if race then
			return race.element
		else
			return false
		end
	end, ...)
end

-- Экспорт методов класса Race
--
-- 				   Название экспорта		 Название метода класса
exportRaceFunction("destroyRace",			 "destroy")
exportRaceFunction("getRaceState",			 "getState")
exportRaceFunction("raceAddPlayer",			 "addPlayer")
exportRaceFunction("raceRemovePlayer",		 "removePlayer")
exportRaceFunction("raceGetPlayers",		 "getPlayers")
exportRaceFunction("raceGetAllPlayers",		 "getAllPlayers")
exportRaceFunction("raceGetTotalPlayersCount","getTotalPlayersCount")
exportRaceFunction("startRace",				 "launch")
exportRaceFunction("finishRace",			 "finish")
exportRaceFunction("raceLogMessage",		 "log")
exportRaceFunction("raceGetFinishedPlayers", "getFinishedPlayers")

-- Экспорт методов MapLoader
loadRaceMap 		= function(...) return safeCall(function(...) return MapLoader.load(...) 	    end, ...) end
createRaceMap 		= function(...) return safeCall(function(...) return MapLoader.createMap(...) 	end, ...) end
getMapsList 		= function(...) return safeCall(function(...) return MapLoader.getMapsList(...) end, ...) end
getMapStartPosition = function(...) return safeCall(function(...) return MapLoader.getMapStartPosition(...) end, ...) end