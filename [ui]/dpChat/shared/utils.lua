function check(value, typeName, argName, functionName)
    if type(value) == typeName then
        return true
    end
    outputDebugString(tostring(functionName) .. ": Expected '" .. tostring(typeName) .. "' at argument '" .. tostring(argName) .. "', got '" .. type(value) .. "'", 2)
    return false
end

function defaultValue(value, defaultValue)
    if value == nil then
        return defaultValue
    end
    return value
end
