(function ()
    local functionsList = {
        "fileOpen",
        "fileExists",
        "fileRename",
        "fileCreate",
        "fileCopy",
        "fileDelete",
        "dxCreateFont",
        "DxFont",
        "dxCreateTexture",
        "DxTexture",
        "dxCreateShader",
        "DxShader",
        "engineLoadDFF",
        "EngineDFF",
        "engineLoadTXD",
        "EngineTXD",
        "engineLoadCOL",
        "EngineCOL",
        "playSound",
        "playSound3D",
        "Sound",
        "Sound3D"
    }

    if not _exclude_paths then
        _exclude_paths = {}
    end

    -- Таблица для более быстрого доступа
    local excludedPaths = {}
    for i, path in ipairs(_exclude_paths) do
        excludedPaths[path] = true
    end

    for i, name in ipairs(functionsList) do
        local fn = _G[name]
        if fn then
            _G[name] = function (path, ...)
                if type(path) ~= "string" then
                    return fn(path, ...)
                end
                if excludedPaths[path] then
                    return fn(path, ...)
                end         
                return fn(md5("dp" .. path), ...)
            end
        end
    end
end)();