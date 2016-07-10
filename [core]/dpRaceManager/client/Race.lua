Race = {}
Race.state = nil
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

Race.addMethod("onJoin", function ()
	Race.start()
end)

Race.addMethod("onLeave", function ()
	Race.stop()
end)

Race.addMethod("updateState", function (state)
	Race.state = state
end)

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