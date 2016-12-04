function arrayToString(array)
    local str = "{"
    for i, v in ipairs(array) do
        if type(v) == "number" or type(v) == "boolean" then
            str = str .. tostring(v)
        else
            str = str .. "\"" .. tostring(v) .. "\""
        end
        if i < #array then
            str = str .. ","
        end
    end
    return str .. "}"
end

function defaultValue(value, default)
    if value == nil then
        return default
    else
        return value
    end
end

function loadFile(path, count)
    local file = fileOpen(path)
    if not file then
        return false
    end
    if not count then
        count = fileGetSize(file)
    end
    local data = fileRead(file, count)
    fileClose(file)
    return data
end

function saveFile(path, data)
    if not path then
        return false
    end
    if fileExists(path) then
        fileDelete(path)
    end
    local file = fileCreate(path)
    fileWrite(file, data)
    fileClose(file)
    return true
end