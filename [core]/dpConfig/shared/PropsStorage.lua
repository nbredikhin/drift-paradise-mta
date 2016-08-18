PropsStorage = {}
local storagePath = "props"
local storage = {}

local function loadFile(path)
	if type(path) ~= "string" then
		return false
	end

	if not File.exists(path) then
		return false
	end

	local file = File(path)
	if not file then
		return false
	end

	local data = file:read(file.size)
	file:close()

	return data
end

local function saveFile(path, data)
	if type(path) ~= "string" then
		return false
	end
	if File.exists(path) then
		File.delete(path)
	end

	local file = File.new(path)
	file:write(data)
	file:close()

	return true
end

function PropsStorage.init(path)
	if type(path) ~= "string" then
		return false
	end
	storagePath = "@" .. path
	local json = loadFile(storagePath)
	if json then
		storage = fromJSON(json)
		if not storage then
			storage = {}
		end
	end
	PropsStorage.save()
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
