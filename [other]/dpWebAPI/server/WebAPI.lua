WebAPI = {}
local registeredMethods = {}
local currentMethodName

function api(methodName, ...)
	if type(methodName) ~= "string" then
		return "Invalid method name. Expected 'string', got '" .. tostring(type(methodName)) .. "'"
	end
	if not registeredMethods[methodName] then
		return "Unknown API method"
	end
	return WebAPI.callMethod(methodName, ...)
end

function WebAPI.log(message)
	if not currentMethodName then
		return false
	end
	outputDebugString("WebAPI: '" .. tostring(currentMethodName) .. "': " .. tostring(message))
end

function WebAPI.registerMethod(name, func)
	if not check("WebAPI.registerMethod", "name", "string", name) then return false end
	if not check("WebAPI.registerMethod", "func", "function", func) then return false end
	if registeredMethods[name] then
		outputDebugString("WebAPI.registerMethod: Method '" .. tostring(name) .. "' is already registered")
		return false
	end
	registeredMethods[name] = func
	return true
end

function WebAPI.callMethod(name, ...)
	if not check("WebAPI.callMethod", "name", "string", name) then return false end
	if not registeredMethods[name] then
		outputDebugString("WebAPI.callMethod: Method '" .. tostring(name) .. "' is not registered")
		return false
	end
	currentMethodName = name
	local result = registeredMethods[name](...)
	currentMethodName = nil
	if type(result) == "string" then
		WebAPI.log("Error: " .. result)
	end
	return result
end