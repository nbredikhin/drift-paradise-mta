local ENCRYPT_CMD = "encrypt"
local resourcesList = {"MazdaMX5Miata", "Nissan240sx", "NissanGTR"}
local files = {"1.txd", "1.dff"}

local function loadFile(path)
	local file = fileOpen(path)
	if not file then
		return false
	end
	local data = fileRead(file, fileGetSize(file))
	fileClose(file)
	return data
end

local function saveFile(path, data)
	if not path then
		return fals
	end
	if fileExists(path) then
		fileDelete(path)
	end
	local file = fileCreate(path)
	fileWrite(file, data)
	fileClose(file)
	return true
end

local function encryptResource(resource)
	outputChatBox(resource.name)
	for i, name in ipairs(files) do
		local file = loadFile(":" .. resource.name .. "/" .. name)
		file = teaEncode(file, "sooqa")
		saveFile(":" .. resource.name .. "/e" .. name, file)
	end
end

local function encryptResources()
	for i, name in ipairs(resourcesList) do
		local resource = getResourceFromName(name)
		encryptResource(resource)
	end
end

addCommandHandler(ENCRYPT_CMD, function ()
	encryptResources()
end)