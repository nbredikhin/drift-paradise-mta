PropsStorage = {}
local storagePath = "props"
local storage = {}

local function loadFile(path)
	local file = fileOpen(path)
	if not file then
		return false
	end
	local data = fileRead(file, file.size)
	fileClose(file)
	return data
end

local function saveFile(path, data)
	if not path then
		return false
	end
	if fileExists(path) then
		fileDelete(path)
	end
	local file = fileCreate(path)
	fileWrite(file, data)
	fileClose(file)
	return true
end

function PropsStorage.init(path)
	if type(path) ~= "string" then
		return false
	end
	storagePath = path
	local json = loadFile(path)
	if json then
		storage = fromJSON(json)
		if not storage then
			storage = {}
		end
	end
	return true
end

function PropsStorage.save()
	local json = toJSON(storage)
	saveFile(storagePath, json)
end

function PropsStorage.set(key, value)
	if type(key) ~= "string" then
		return false
	end
	storage[key] = value
	PropsStorage.save()
	triggerEvent("dpConfig.update", resourceRoot, key, value)
	return true
end

function PropsStorage.setDefault(key, value)
	if type(key) ~= "string" then
		return false
	end
	if storage[key] == nil then
		storage[key] = value
	end
	return true
end

function PropsStorage.get(key)
	if type(key) ~= "string" then
		return false
	end
	return storage[key]
end