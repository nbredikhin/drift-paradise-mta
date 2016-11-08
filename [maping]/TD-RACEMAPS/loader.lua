local types = {"dff", "txd", "col"}

local loadedFiles = {}
local loadedModels = {}
local loadedLODs = {}

local function getFileType(src)
    for i, t in ipairs(types) do
        if string.find(src, t, 1, true) then
            return t
        end
    end
    return false
end

local function loadFile(file)
    local fileType = getFileType(file.src)

    if fileType == "txd" then
        local txd = loadedFiles[file.src]
        if not txd then
            txd = engineLoadTXD(file.src)
            loadedFiles[file.src] = txd
        end
        engineImportTXD(txd, file.model) 
    elseif not loadedFiles[file.src] then
        if fileType == "dff" then
            local dff = engineLoadDFF(file.src)
            engineReplaceModel(dff, file.model)
            loadedFiles[file.src] = dff
        elseif fileType == "col" then
            local col = engineLoadCOL(file.src)
            engineReplaceCOL(col, file.model)
            loadedFiles[file.src] = col
        end
    end

    if not loadedModels[file.model] then
        loadedModels[file.model] = true
        engineSetModelLODDistance(file.model, 300)
    end
end

function loadMap(name, createLODs)
    if not name then
        return false
    end
    if not maps[name] then
        return false
    end

    for i, file in ipairs(maps[name]) do
        loadFile(file)        
    end
    createLODs = true
    if createLODs then
        for i, object in ipairs(getElementsByType("object")) do
            if loadedModels[object.model] then
                local objectLOD = createObject(object.model, object.position, object.rotation, true)
                object.lowLOD = objectLOD
                table.insert(loadedLODs, objectLOD)
            end
        end
    end
end

function unloadMap()
    for model in pairs(loadedModels) do
        engineRestoreCOL(model)
        engineRestoreModel(model)
    end
    for src, element in pairs(loadedFiles) do
        if isElement(element) then
            destroyElement(element)
        end
    end
    for i, object in ipairs(loadedLODs) do
        if isElement(object) then
            destroyElement(object)
        end
    end
    loadedModels = {}
    loadedFiles = {}
    loadedLODs = {}
end

bindKey("k", "down", function ()
    for i, object in ipairs(loadedLODs) do
        if isElement(object) then
            destroyElement(object)
        end
    end
    loadedLODs = {}
end)