Race = {}
Race.state = nil
Race.settings = {}

local isActive = false
local rpcMethods = {}

function Race.start()
	if isActive then
		return false
	end
	isActive = true
	Race.state = nil
	outputDebugString("Client race start")
end

function Race.stop()
	if not isActive then
		return false
	end
	isActive = false
	Race.state = nil
	outputDebugString("Client race stop")
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
Race.addMethod("onJoin", function (settings)
	Race.settings = settings
	Race.start()
end)

-- Локальный игрок покинул гонку
Race.addMethod("onLeave", function ()
	Race.stop()
end)

-- Изменилось состоние гонки
Race.addMethod("updateState", function (state)
	Race.state = state
end)