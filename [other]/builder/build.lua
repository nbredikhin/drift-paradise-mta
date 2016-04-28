-- Автоматическая компиляция всех скриптов
local LUAC_URL = "http://luac.mtasa.com/?compile=1&debug=0&obfuscate=0"
local BUILD_FILE_NAME = "build.json"
local RESOURCE_PREFIX = "dp"
local SECRET_KEY = "mda_xex_memasiki_podkatili"
local SCRIPTS_PATH = md5("scripts")
local BUILD_CMD = "build"
local buildInfo = {}

local compileScriptsTotal = 0
local compileScriptsCurrent = 0

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
	local builtSrc = md5(SECRET_KEY .. resource.name) .. "/" .. sha256(src .. SECRET_KEY)
	copyFile(":" .. resource.name .. "/" .. src, outPath .. "/" .. builtSrc)

	local fileData = loadFile(":" .. resource.name .. "/" .. src)
	if fileData then
		fetchRemote(LUAC_URL, writeCompiledScript, fileData, false, outPath .. "/" .. builtSrc)
		compileScriptsTotal = compileScriptsTotal + 1
	end
	return builtSrc
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
	for i, child in ipairs(oldMeta.children) do
		local newChild = newMeta:createChild(child.name)
		if child.name == "script" then
			local scriptSrc = child:getAttribute("src")
			local scriptType = child:getAttribute("type")
			local builtSrc = buildScript(resource, scriptSrc, scriptType, buildPath)

			newChild:setAttribute("type", scriptType)
			newChild:setAttribute("src", builtSrc)
			newChild:setAttribute("cache", "false")
		else
			local src = child:getAttribute("src")
			if src then
				copyFile(resourcePath .. src, buildPath .. src)
				createReadme = true
			end

			for name, value in pairs(child.attributes) do
				newChild:setAttribute(name, value)
			end
			newChild.value = child.value
		end
	end
	if createReadme then
		copyFile("README.txt", buildPath .. "/README.txt")
		local readmeChild = newMeta:createChild("file")
		readmeChild:setAttribute("src", "README.txt")
	end
	oldMeta:unload()
	newMeta:saveFile()
	newMeta:unload()

	
end

local function buildResources()
	for i, resource in ipairs(getResources()) do
		if string.sub(resource.name, 1, string.len(RESOURCE_PREFIX)) == RESOURCE_PREFIX then
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