-- Секретный ключ, использующийся для шифрования
local SECRET_KEY = "RcgZgMGbs5yBbdsme8SJn2dE"

-- Название DFF и TXD файлов
local fileName = "1"

-- Список ресурсов, который нужно залочить при запуске
-- Название и модель, которую нужно заменить
local lockResources = {
	{"DP-Nissan240sx", 411}
}

-- Расширения файлов, которые нужно лочить
local fileExtensions = { "dff", "txd" }

local function loadFile(path, count)
	local file = fileOpen(path)
	if not file then
		return false
	end
	if not count then
		count = fileGetSize(file)
	end
	local data = fileRead(file, count)
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

local function lockFile(path, lockedPath)
	if not fileExists(path) then
		return false
	end
	if not lockedPath then
		lockedPath = path .. ".locked"
	end
	local data = loadFile(path)
	outputConsole("Locked file: " .. tostring(path))
	return teaEncode(
			base64Encode(data),
			SECRET_KEY)
	-- saveFile(
	-- 	lockedPath,
	-- 	teaEncode(
	-- 		base64Encode(data),
	-- 		SECRET_KEY))
end

local function processResource(resource, model)
	if not resource then
		return false
	end
	local lockedFiles = {}
	for i, ext in ipairs(fileExtensions) do
		local sourceFilePath = ":" .. tostring(resource.name) .. "/" .. tostring(fileName) .. "." .. tostring(ext)
		local lockedFileName = md5(tostring(fileName) .. tostring(locked) .. "." .. tostring(ext))
		local lockedFilePath = ":" .. tostring(resource.name) .. "/" .. lockedFileName
		-- Шифруем файл
		local result = lockFile(sourceFilePath, lockedFilePath)
		if result then
			table.insert(lockedFiles, 
				string.format(
					"\t{data=\"%s\", type=\"%s\"}", base64Encode(result), ext))
		else
			outputConsole("Failed to lock file: " .. tostring(sourceFilePath))
		end
	end
	if #lockedFiles > 0 then
		local script = string.format(
			loadFile("loader.lua"),
			SECRET_KEY,
			table.concat(lockedFiles, ","))

		script = [[-- Скрипт сгенерирован автоматически
-- Рекомендуется скомпилировать этот скрипт через luac.mtasa.com

MODEL = ]] .. tostring(model) .. [[ -- Модель, которую нужно заменить

-- Загрузчик
]] .. script .. [[]]
		saveFile(":" .. tostring(resource.name) .. "/pack.lua", script)
	end
	return true
end

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, res in ipairs(lockResources) do
		if processResource(Resource.getFromName(res[1]), res[2]) then
			outputConsole("Locked " .. tostring(res[1]) .. " (".. tostring(res[2]) ..")")
		else
			outputConsole("Failed to lock " .. tostring(res[1]))
		end
	end
end)