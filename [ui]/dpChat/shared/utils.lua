IS_SERVER = not not triggerClientEvent

function check(value, typeName, argName, functionName)
    if type(value) == typeName then
        return true
    end
    outputDebugString("[" .. (IS_SERVER and "SERVER" or "CLIENT") .. "] " .. tostring(functionName) .. ": Expected " .. tostring(typeName) .. " at argument '" .. tostring(argName) .. "', got " .. type(value) .. "", 2)
    return false
end

-- function checkElement(value, elementTypeName, argName, functionName)
--     if isElement(value) and type(elementTypeName) == "string" and value:getType() == elementTypeName then
--         return true
--     end
--     outputDebugString("[" .. (IS_SERVER and "SERVER" or "CLIENT") .. "] " .. tostring(functionName) .. ": Expected " .. tostring(typeName) .. " at argument '" .. tostring(argName) .. "', got " .. type(value) .. "", 2)
--     return false
-- end

function defaultValue(value, defaultValue)
    if value == nil then
        return defaultValue
    end
    return value
end

function removeDoubleSpaces(s)
    return s:gsub("%s%s+", " ")
end

function trimSpaces(s)
    local n = s:find("%S")
    return n and s:match(".*%S", n) or ""
end
