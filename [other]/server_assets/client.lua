local PACK_HEADER_BYTES = {0xBD, 0x01, 0x28, 0x78, 0x37, 0x20, 0x51, 0xC9}
local PACK_FILE_HEADER_BYTES = {0x01, 0x22, 0xF0, 0x92, 0xFF, 0x02, 0xDE, 0x03}

local packs = {
    { name = "cars", preload = true }
}

local loadedPacks = {}

local function compareArrays(a1, a2)
    for i, v in ipairs(a1) do
        if a2[i] ~= v then
            return false
        end
    end
    return true
end

local function loadModel(modelType, model, data)
    local path = md5(tostring(model) .. "-" .. tostring(modelType)) .. "_DPASSET"
    local file = fileCreate(path)
    file:write(data)
    file:close()

    local element
    if modelType == 1 then
        element = engineLoadDFF(path)
        engineReplaceModel(element, model)
    elseif modelType == 2 then
        element = engineLoadTXD(path)
        engineImportTXD(element, model)
    elseif modelType == 3 then
        element = engineLoadCOL(path)
        engineImportCOL(element, model)
    end
    fileDelete(path)
    return element
end

function unloadPack(packName)
    if not loadedPacks[packName] then
        return false
    end

    for i, model in ipairs(loadedPacks[packName].models) do
        engineRestoreCOL(model)
        engineRestoreModel(model)
    end

    for i, element in ipairs(loadedPacks[packName].elements) do
        if isElement(element) then
            destroyElement(element)
        end
    end

    loadedPacks[packName] = nil
end

function loadPack(packName)
    if not packName then
        return false
    end
    if loadedPacks[packName] then
        return false
    end
    local file = fileOpen("packs/" .. packName .. ".pack")
    if not file then
        outputDebugString("Pack " .. tostring(packName) .. " not found")
        return
    end
    local packData = struct.pack(string.rep("B", #PACK_HEADER_BYTES), unpack(PACK_HEADER_BYTES))
    local packFileHeader = struct.pack(string.rep("B", #PACK_FILE_HEADER_BYTES), unpack(PACK_FILE_HEADER_BYTES))

    local header = fileRead(file, #PACK_HEADER_BYTES)
    local fileHeader = {struct.unpack(string.rep("B", #PACK_HEADER_BYTES), header)}
    if not compareArrays(fileHeader, PACK_HEADER_BYTES) then
        return
    end

    local state = "none"
    local currentHeader = false
    
    local readCount = 0
    loadedPacks[packName] = {
        elements = {},
        models = {}
    }
    while not file.eof do
        local tmpHeader = fileRead(file, #PACK_FILE_HEADER_BYTES)
        if #tmpHeader < 8 then
            break
        end
        tmpHeader = { struct.unpack(string.rep("B", #PACK_FILE_HEADER_BYTES), tmpHeader) }
        if compareArrays(tmpHeader, PACK_FILE_HEADER_BYTES) then
            local fileType = fileRead(file, 1)
            fileType = struct.unpack("B", fileType)
            local model = fileRead(file, 4)
            model = struct.unpack("I", model)
            local size = struct.unpack("I", fileRead(file, 4))
            local data = fileRead(file, size)
            local element = loadModel(fileType, model, data)
            if isElement(element) then
                table.insert(loadedPacks[packName].elements, element)
                table.insert(loadedPacks[packName].models, model)
            end
            readCount = readCount + 1
        end 
    end

    fileClose(file)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, pack in ipairs(packs) do
        if pack.preload then
            loadPack(pack.name)
        end
    end
end)