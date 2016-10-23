function createMethodCallFunc(object, method)
    return function (...)
        outputDebugString(tostring(object) .. " -> " .. tostring(method))
        method(object, ...)
    end
end