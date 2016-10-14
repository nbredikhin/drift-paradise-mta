RPC = {}
local isServer = not not getRandomPlayer
local methods = {}

function RPC.method(methodName, callback)
    if type(methodName) ~= "string" or type(callback) ~= "function" then
        return false
    end
    methods[methodName] = callback
    print("New RPC method: " .. tostring(methodName))
    return true
end

if isServer then
    function RPC.call(client, methodName, ...)
        return triggerClientEvent(client, "dpRPC.call", resourceRoot, methodName, ...)
    end
else
    function RPC.call(methodName, ...)
        return triggerServerEvent("dpRPC.call", resourceRoot, methodName, ...)
    end
end

addEvent("dpRPC.call", true)
addEventHandler("dpRPC.call", resourceRoot, function (methodName, ...)
    if not methods[methodName] then
        return 
    end
    if isServer then
        methods[methodName](client, ...)
    else
        methods[methodName](...)
    end
end)