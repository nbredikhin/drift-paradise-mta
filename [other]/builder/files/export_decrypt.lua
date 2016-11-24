(function ()
    local _exports = exports

    local mt = {}
    mt.__index = function (table, key)
        if type(key ~= "string") then
            return _exports[key]
        else
            return _exports[md5(key)]
        end
    end

    exports = {}
    setmetatable(exports, mt)

    local _getResourceFromName = getResourceFromName
    getResourceFromName = function (name, ...)
        return _getResourceFromName(md5(name), ...)
    end
end)();