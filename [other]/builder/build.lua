-- Автоматическая компиляция всех скриптов
local LUAC_URL = "http://luac.mtasa.com/?compile=1&debug=0&obfuscate=1"
local BUILD_FILE_NAME = "build.json"
local RESOURCE_PREFIX = "dp"
local SECRET_KEY = "mda_xex_memasiki_podkatili"
local SCRIPTS_PATH = md5("scripts")
local BUILD_CMD = "build"
local HELPER_FILE_PATH = "helper.luac"
local buildInfo = {}

local compileScriptsTotal = 0
local compileScriptsCurrent = 0

-- Скомпилировать скрипты через luac.mtasa.com
local COMPILE_SCRIPTS = true
-- cache="false" для всех скриптов
local DISABLE_SCRIPTS_CACHE = true
-- Шифровать пути к скриптам
local ENCRYPT_SCRIPT_PATHS = true
-- Шифровать пути к .png
local ENCRYPT_PNG_PATHS = true

-- Собрать ТОЛЬКО ресурсы из списка
local RESOURCES_TO_BUILD = {dpGreetings = true}
-- Ресурсы, которые не нужно компилировать 
local DISABLE_COMPILE_AND_ENCRYPT = { dpShared = true }

-- Ресурсы, которые нужно собрать помимо ресурсов с префиксом RESOURCE_PREFIX
local INCLUDE_RESOURCES = {
	"geoip",
	"blur_box",
	"car_reflections",
	"water_reflections",
	"dynamic_lighting",
	"dynamic_lighting_vehicles",
	"shader_dynamic_sky"
}

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

local function writeCompiledScript(data, err, path)
	if not data or err > 0 then
		return
	end
	saveFile(path, data)
	compileScriptsCurrent = compileScriptsCurrent + 1
	outputServerLog("Compiling scripts: " .. compileScriptsCurrent .."/" .. compileScriptsTotal)
	if compileScriptsCurrent >= compileScriptsTotal then
		outputServerLog("FINISHED COMPILING SCRIPTS")
	end 
end

local function copyFile(path1, path2)
	local f1 = fileOpen(path1)
	if not f1 then return false end
	if fileExists(path2) then fileDelete(path2) end
	local f2 = fileCreate(path2)
	if not f2 then return false end
	f2:write(f1:read(f1.size))
	f1:close()
	f2:close()
end

local function buildScript(resource, src, type, outPath)
	local builtSrc = src
	if ENCRYPT_SCRIPT_PATHS and not DISABLE_COMPILE_AND_ENCRYPT[resource.name] then
		builtSrc = md5(SECRET_KEY .. resource.name) .. "/" .. sha256(src .. SECRET_KEY)
	end
	copyFile(":" .. resource.name .. "/" .. src, outPath .. "/" .. builtSrc)
	compileScriptsTotal = compileScriptsTotal + 1
	if COMPILE_SCRIPTS and not DISABLE_COMPILE_AND_ENCRYPT[resource.name] then
		local fileData = loadFile(":" .. resource.name .. "/" .. src)
		if fileData then
			fetchRemote(LUAC_URL, writeCompiledScript, fileData, false, outPath .. "/" .. builtSrc)			
		end
	else
		outputServerLog("Building scripts: " .. compileScriptsCurrent)
		compileScriptsCurrent = compileScriptsCurrent + 1
	end
	return builtSrc
end

local function encryptFile(path)
	local data = loadFile(path, 10)
	if not data then
		return false
	end
	data = teaEncode(data, SECRET_KEY)
	return saveFile(path, data)
end

local function buildResource(resource)
	local buildPath = "builds/" .. tostring(buildInfo.id) .. "/" .. resource.name .. "/"
	local resourcePath = ":" .. resource.name .. "/"
	local newMeta = XML(buildPath .. "meta.xml", "meta")
	local oldMeta = XML.load(":" .. resource.name .. "/meta.xml")
	local createReadme = false
	if not oldMeta then
		return false
	end
	
	if ENCRYPT_PNG_PATHS then
		local helperFileName = md5(math.random(1, 1000))
		copyFile(HELPER_FILE_PATH, buildPath .. "/" .. helperFileName)
		local helperChild = newMeta:createChild("script")
		helperChild:setAttribute("src", helperFileName)
		helperChild:setAttribute("type", "client")
		helperChild:setAttribute("cache", "false")
	end
	for i, child in ipairs(oldMeta.children) do
		local newChild = newMeta:createChild(child.name)
		if child.name == "script" then
			local scriptSrc = child:getAttribute("src")
			local scriptType = child:getAttribute("type")
			local builtSrc = buildScript(resource, scriptSrc, scriptType, buildPath)

			newChild:setAttribute("type", scriptType)
			newChild:setAttribute("src", builtSrc)
			if DISABLE_SCRIPTS_CACHE then
				newChild:setAttribute("cache", "false")
			end
		else
			local src = child:getAttribute("src")
			if src then
				if string.find(src, ".png") and ENCRYPT_PNG_PATHS then
					local encodedSrc = md5(teaEncode(src, "kek"))
					copyFile(resourcePath .. src, buildPath .. encodedSrc)
					newChild:setAttribute("src", encodedSrc)
				else
					copyFile(resourcePath .. src, buildPath .. src)
				end
				createReadme = true
			end

			-- Скопировать остальные аттрибуты
			for name, value in pairs(child.attributes) do
				if not newChild:getAttribute(name) then
					newChild:setAttribute(name, value)
				end
			end
			newChild.value = child.value
		end
	end
	copyFile("README.txt", buildPath .. "/README.txt")
	if createReadme then
		local readmeChild = newMeta:createChild("file")
		readmeChild:setAttribute("src", "README.txt")
	end
	oldMeta:unload()
	newMeta:saveFile()
	newMeta:unload()
end

-- Находится ли ресурс с названием name в списке INCLUDE_RESOURCES
local function isResourceIncluded(name)
	for i, n in ipairs(INCLUDE_RESOURCES) do
		if n == name then
			return true
		end
	end
	return false
end

local function buildResources()
	local resourcesList = getResources()
	if RESOURCES_TO_BUILD then
		local res = {}
		for i, resource in ipairs(resourcesList) do
			if RESOURCES_TO_BUILD[resource.name] then
				table.insert(res, resource)
			end
		end
		resourcesList = res
	end
	for i, resource in ipairs(resourcesList) do
		if isResourceIncluded(resource.name) or string.sub(resource.name, 1, string.len(RESOURCE_PREFIX)) == RESOURCE_PREFIX then
			buildResource(resource)
		end
	end
end

local function build()
	-- Создание build-файла с номером сборки
	if not fileExists(BUILD_FILE_NAME) then
		fileCreate(BUILD_FILE_NAME)
	end
	local buildfile = fileOpen(BUILD_FILE_NAME, true)
	buildInfo = fromJSON(buildfile:read(buildfile.size))
	if not buildInfo then 
		buildInfo = {} 
	end
	if not buildInfo.id then buildInfo.id = 0 end
	buildInfo.timestamp = getRealTime().timestamp
	buildInfo.id = tonumber(buildInfo.id) + 1
	buildfile:close()

	buildfile = fileOpen(BUILD_FILE_NAME)
	buildfile:write(toJSON(buildInfo))
	buildfile:close()
	
	buildResources()
	return true
end

addCommandHandler(BUILD_CMD, function ()
	compileScriptsCurrent = 0
	compileScriptsTotal = 0
	outputServerLog("Building server...")
	build()
	outputServerLog("Build " .. tostring(buildInfo.id) .. " was successfully created")
end)