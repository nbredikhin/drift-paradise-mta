local PACK_HEADER_BYTES = {0xBD, 0x01, 0x28, 0x78, 0x37, 0x20, 0x51, 0xC9}
local PACK_FILE_HEADER_BYTES = {0x01, 0x22, 0xF0, 0x92, 0xFF, 0x02, 0xDE, 0x03}
local versionNumber = 1

local function getFileType(path)
    local fileTypes = {"dff", "txd", "col"}
    for i, t in ipairs(fileTypes) do
        if string.find(path, "." .. t, 1, true) then
            return t
        end
    end
    return false 
end

addCommandHandler("pack", function (player, cmd, packName)
    if type(packName) ~= "string" then
        outputDebugString("Invalid pack name")
        return
    end
    local packXML = XML.load(packName .. ".xml")
    if not packXML then
        outputDebugString("Failed to load pack '" .. packName .. "'")
        return
    end

    local packData = struct.pack(string.rep("B", #PACK_HEADER_BYTES), unpack(PACK_HEADER_BYTES))
    local packFileHeader = struct.pack(string.rep("B", #PACK_FILE_HEADER_BYTES), unpack(PACK_FILE_HEADER_BYTES))
    underscore.each(packXML.children, function (packFile)
        local model = packFile:getAttribute("replace")
        local src = packFile:getAttribute("src")
        local fileType = getFileType(src)

        local fileData = loadFile(src)
        if not fileData then
            return
        end

        if fileType == "dff" then
            fileType = 1
        elseif fileType == "txd" then
            fileType = 2
        elseif fileType == "col" then
            fileType = 3
        else
            fileType = 0
        end

        packData = packData
            .. packFileHeader
            .. struct.pack("B", fileType)
            .. struct.pack("I", tonumber(model))
            .. struct.pack("I", #fileData)
            .. fileData
    end)

    saveFile("packs/" .. packName .. ".pack", packData)
    outputDebugString("Created pack 'packs/" .. packName .. ".pack'")
end)