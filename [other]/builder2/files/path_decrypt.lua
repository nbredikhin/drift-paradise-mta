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
        "EngineCOL"
    }

    for i, name in ipairs(functionsList) do
        local fn = _G[name]
        _G[name] = function (path, ...)
            return fn(md5("dp" .. path), ...)
        end
    end
end)();