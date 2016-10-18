function print(...)
    local args = {...}
    local output = ""
    for i, v in ipairs(args) do
        output = output .. tostring(v)
        if i < #args then
            output = output .. "\t"
        end
    end
    outputDebugString(output)
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

function copyFile(path1, path2)
    return fileCopy(path1, path2, true)
    -- local f1 = fileOpen(path1)
    -- if not f1 then return false end
    -- if fileExists(path2) then fileDelete(path2) end
    -- local f2 = fileCreate(path2)
    -- if not f2 then return false end
    -- f2:write(f1:read(f1.size))
    -- f1:close()
    -- f2:close()
end