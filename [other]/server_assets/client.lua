local PACK_HEADER_BYTES = {0xBD, 0x01, 0x28, 0x78, 0x37, 0x20, 0x51, 0xC9}
local PACK_FILE_HEADER_BYTES = {0x01, 0x22, 0xF0, 0x92, 0xFF, 0x02, 0xDE, 0x03}

local packs = {
    "cars"
}

local function compareArrays(a1, a2)
    for i, v in ipairs(a1) do
        if a2[i] ~= v then
            return false
        end
    end
    return true
end

local function loadModel(modelType, model, data)
    outputDebugString("Load model " .. #data)
    local path = "tmp/" .. md5(tostring(model) .. "-" .. tostring(modelType))
    local file = fileCreate(path)
    file:write(data)
    file:close()

    if modelType == 1 then
        local dff = engineLoadDFF(path)
        engineReplaceModel(dff, model)
    elseif modelType == 2 then
        local txd = engineLoadTXD(path)
        engineImportTXD(txd, model)
    end
    fileDelete(path)
end

local function loadPack(packName)
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
        outputDebugString("Invalid header")
        return
    end

    local state = "none"
    local currentHeader = false
    
    local readCount = 0
    while not file.eof do
        local tmpHeader = fileRead(file, #PACK_FILE_HEADER_BYTES)
        if #tmpHeader < 8 then
            outputDebugString("End of pack")
            break
        end
        tmpHeader = {struct.unpack(string.rep("B", #PACK_FILE_HEADER_BYTES), tmpHeader)}
        if compareArrays(tmpHeader, PACK_FILE_HEADER_BYTES) then
            local fileType = fileRead(file, 1)
            fileType = struct.unpack("B", fileType)
            local model = fileRead(file, 4)
            model = struct.unpack("I", model)
            local size = struct.unpack("I", fileRead(file, 4))
            outputDebugString("File type: " .. tostring(fileType) .. " model: " .. tostring(model) .. " size: " .. tostring(size))
            local data = fileRead(file, size)
            loadModel(fileType, model, data)
            readCount = readCount + 1
        end 
    end
    outputDebugString("Unpacked " .. tostring(readCount) .. " file(s)")

    fileClose(file)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, packName in ipairs(packs) do
        loadPack(packName)
    end
end)