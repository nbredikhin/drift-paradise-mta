(function ()
    local functionsList = {
        "fileOpen",
        "fileExists",
        "fileRename",
        "fileCreate",
        "fileCopy",        
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

    local excludePaths = _exclude_paths
    if not excludePaths then
        excludePaths = {}
    end

    for i, name in ipairs(functionsList) do
        local fn = _G[name]
        if fn then
            _G[name] = function (path, ...)
                if type(path) ~= "string" then
                    return fn(path, ...)
                end
                for i,p in ipairs(excludePaths) do
                    if string.find(path, p, 1, false) then
                        return fn(path, ...)
                    end
                end           
                return fn(md5("dp" .. path), ...)
            end
        end
    end
end)();