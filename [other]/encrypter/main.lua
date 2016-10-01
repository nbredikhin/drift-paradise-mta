-- Название DFF и TXD файлов
local fileName = "1"

-- Список ресурсов, который нужно залочить при запуске
-- Название и модель, которую нужно заменить
local lockResources = {
	{"DP-ToyotaAE86", 589},
	{"DP-Nissan240sx", 602},
	{"DP-MazdaMX5Miata", 411},
}
local counter = 0

-- Расширения файлов, которые нужно лочить
local fileExtensions = { "dff", "txd" }

local function lockFile(path, lockedPath)
	if not fileExists(path) then
		return false
	end
	if not lockedPath then
		lockedPath = path .. ".locked"
	end
	local data = FileUtils.loadFile(path)
	outputConsole("Locked file: " .. tostring(path))
	FileUtils.saveFile(lockedPath, Encrypter.encode(data))
	return true
end

local function buildScript(fileData, outPath)
	fetchRemote("http://luac.mtasa.com/?compile=1&debug=0&obfuscate=1", function(data, err, path)
		if not data or err > 0 then
			return
		end
		FileUtils.saveFile(outPath, data)
		counter = counter + 1
		if counter >= #lockResources then
			outputServerLog("DONE")
		else
			outputServerLog(string.format("Locking... %s/%s", counter, #lockResources))
		end
	end, fileData, false)	
end

local function processResource(resource, model)
	if not resource then
		return false
	end
	local meta = "<meta>\n<oop>true</oop>\n"
	local lockedFiles = {}
	for i, ext in ipairs(fileExtensions) do
		local sourceFilePath = ":" .. tostring(resource.name) .. "/" .. tostring(fileName) .. "." .. tostring(ext)
		local lockedFileName = md5(tostring(fileName) .. tostring(locked) .. "." .. tostring(ext))
		local lockedFilePath = ":" .. tostring(resource.name) .. "/" .. lockedFileName
		-- Шифруем файл
		local result = lockFile(sourceFilePath, lockedFilePath)
		if result then
			meta = meta .. "<file src=\"" .. lockedFileName .. "\"/>\n"
			table.insert(lockedFiles, 
				string.format(
					"\t{data=\"%s\", type=\"%s\"}", lockedFilePath, ext))
		else
			outputConsole("Failed to lock file: " .. tostring(sourceFilePath))
		end
	end
	if #lockedFiles > 0 then
		local script = FileUtils.loadFile("loader.lua")
		script = [[--DIS NO BREK PLIS
MODEL = ]] .. tostring(model) .. [[ -- Модель, которую нужно заменить
SUS = "]] .. Encrypter.SECRET_KEY .. [["
local DUNNO_WAT= {]] .. table.concat(lockedFiles, ",") .. [[}
-- DIS TO
]] .. script .. [[]]
		local sname = md5(tostring(resource.name) .. "-pack.lua")
		meta = meta .. "<script type=\"client\" src=\"" .. sname .. "\"/>\n"
		meta = meta .. "</meta>"
		FileUtils.saveFile(":" .. tostring(resource.name) .. "/" .. sname, script)
		FileUtils.saveFile(":" .. tostring(resource.name) .. "/meta.xml", meta)

		buildScript(script, ":" .. tostring(resource.name) .. "/" .. sname)
	end
	return true
end

addEventHandler("onResourceStart", resourceRoot, function ()
	counter = 0
	for i, res in ipairs(lockResources) do
		if processResource(Resource.getFromName(res[1]), res[2]) then
			outputConsole("Locked " .. tostring(res[1]) .. " (".. tostring(res[2]) ..")")
		else
			outputConsole("Failed to lock " .. tostring(res[1]))
		end
	end
end)