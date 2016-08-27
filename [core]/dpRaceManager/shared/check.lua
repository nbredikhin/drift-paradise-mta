function check(functionName, argumentName, expectedType, value)
	if type(functionName) ~= "string" or type(argumentName) ~= "string" or type(expectedType) ~= "string" then
		outputDebugString("Bad usage of \"check\" function")
		return true
	end
	local result = true
	if expectedType == "element" then
		result = isElement(value)
	elseif expectedType == "player" then
		result = isElement(value) and value.type == "player"
	elseif expectedType == "vehicle" then
		result = isElement(value) and value.type == "vehicle"
	else
		result = type(value) == expectedType
	end

	if not result then
		outputDebugString(string.format("%s: '%s' must be '%s', got '%s'", functionName, argumentName, expectedType, tostring(type(value))))
	end
	return result
end