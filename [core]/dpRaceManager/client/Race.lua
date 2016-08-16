Race = {}
Race.state = nil
Race.settings = {}

local raceObjects = {}
Race.dimension = 0

local isActive = false
local rpcMethods = {}

function Race.start()
	if isActive then
		return false
	end
	isActive = true
	Race.state = nil
	RaceUI.start()	
end

function Race.stop()
	if not isActive then
		return false
	end
	isActive = false
	Race.state = nil
	RaceUI.stop()

	for i, object in ipairs(raceObjects) do
		if isElement(object) then
			destroyElement(object)
		end
	end
	raceObjects = {}
	RaceCheckpoints.stop()
end

-- RPC
function Race.addMethod(name, callback)
	if type(name) ~= "string" or type(callback) ~= "function" then
		return false
	end
	rpcMethods[name] = callback
	return true
end

addEvent("dpRaceManager.rpc", true)
addEventHandler("dpRaceManager.rpc", resourceRoot, function (name, ...)
	if type(name) ~= "string" then
		return
	end
	if type(rpcMethods[name]) ~= "function" then
		return
	end
	rpcMethods[name](...)
end)

-- Локальный игрок присоединился к гонке
Race.addMethod("onJoin", function (settings, dimension)
	Race.settings = settings
	Race.dimension = dimension
	if not Race.dimension then 
		Race.dimension = 0
	end
	Race.start()
end)

-- Локальный игрок покинул гонку
Race.addMethod("onLeave", function ()
	Race.stop()
end)

-- Изменилось состоние гонки
Race.addMethod("updateState", function (state)
	Race.state = state
	RaceUI.setState(state)
end)

-- Сервер отправил карту
Race.addMethod("loadMap", function (mapJSON)
	local map = fromJSON(mapJSON)

	if type(map.objects) == "table" then
		for i, o in ipairs(map.objects) do
			local object = createObject(unpack(o))
			object.dimension = Race.dimension
			table.insert(raceObjects, object)
		end
	end	
	if type(map.checkpoints) == "table" then
		RaceCheckpoints.start(map.checkpoints)
	end
end)

Race.addMethod("showCountdown", function()
	RaceUI.showCountdown()
end)