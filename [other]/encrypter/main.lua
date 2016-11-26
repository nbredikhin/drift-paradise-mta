local config = {}
local OUT_RESOURCE_NAME = "server_assets"
local BUILD_FOLDER = ":"

local builtVehicles = {}

local function randomBytes(count, seed)
	if seed then
		math.randomseed(seed)
	end
	local str = ""
	for i = 1, count do
		str = str .. string.char(math.random(0, 255))
	end
	return str
end

local function encryptVehicleResource(resource, model)
	local resourcePath = ":" .. resource.name .. "/"
	local resourceMeta = XML.load(resourcePath .. "meta.xml")
    if not resourceMeta then
        print("Failed to open resource '" .. tostring(resource.name) .. "'")
        return
    end	

    local paths = {}
    underscore.each(resourceMeta.children, function (child)
    	if child.name ~= "file" then
    		return
    	end
    	local path = child:getAttribute("src")
    	if not path then
    		return
    	end
    	if string.find(path, "dff") then
    		paths.dff = path
    	elseif string.find(path, "txd") then
    		paths.txd = path
    	end
    end)

    if not paths.dff then 
    	print("Missing DFF for '" .. tostring(resource.name) .. "'")
    	return false
    end
    if not paths.txd then 
    	print("Missing TXD for '" .. tostring(resource.name) .. "'")
    	return false
    end

    local buildPath = BUILD_FOLDER .. OUT_RESOURCE_NAME .. "/"
    local dff = loadFile(resourcePath .. paths.dff)
    local txd = loadFile(resourcePath .. paths.txd)

    local seed = #dff + #txd

    local randomHeader = randomBytes(8, seed) .. "DRIFT_PARADISE_ASSET" .. randomBytes(math.random(1024, 1024 * 4), seed)

    local outputFileData = randomHeader .. dff .. txd
    local outputFileName = tostring("dp_" .. tostring(model)) .. ".bin"
    saveFile(buildPath .. outputFileName, outputFileData)

    table.insert(builtVehicles, {
    	model,
    	outputFileName,
    	#randomHeader,
    	#dff,
    	#txd
    })

    print("Built '" .. tostring(resource.name) .. "'")
	return true
end 

addCommandHandler("encrypt", function ()
    print("Car enctypter started")
    -- Чтение конфига
    local configJSON = loadFile("config.json")
    if not configJSON then
        print("Failed to open config.json")
        return
    end
    config = fromJSON(configJSON)
    if not config then
        print("Failed to read config.json")
        return
    end

    -- Сборка
    local vehiclesTable = exports.dpShared:getVehiclesTable()

    print("Building...")
    builtVehicles = {}
    local successCount = 0
    local failCount = 0
    for name, model in pairs(vehiclesTable) do
    	local resource = getResourceFromName(name)
    	if not resource then
    		failCount = failCount + 1
    	else
    		if encryptVehicleResource(resource, model) then
    			successCount = successCount + 1
    		else
    			failCount = failCount + 1
    		end
    	end
    end

    -- Создание меты
    local buildPath = BUILD_FOLDER .. OUT_RESOURCE_NAME .. "/"
    local meta =  XML(buildPath .. "meta.xml", "meta")
    meta:createChild("oop").value = "true"
    local vehiclesArrayString = "{\n"
    for i, info in ipairs(builtVehicles) do
    	local fileChild = meta:createChild("file")
    	fileChild:setAttribute("src", info[2])
    	vehiclesArrayString = vehiclesArrayString .. "\t" .. arrayToString(info) .. ",\n"
    end
    vehiclesArrayString = vehiclesArrayString .. "};"

    -- Loader
    local scriptChild = meta:createChild("script")
    local loaderFile = ""
    loaderFile = loaderFile .. "VEHICLES_LIST = " .. vehiclesArrayString .. "\n\n"
    loaderFile = loaderFile .. loadFile("files/loader.lua") .. "\n"
    local loaderFilePath = "loader.lua"
    saveFile(buildPath .. loaderFilePath, loaderFile)
    scriptChild:setAttribute("type", "client")  
    scriptChild:setAttribute("src", loaderFilePath)
    scriptChild:setAttribute("cache", "false")    

    meta:saveFile()
    meta:unload()

    print("Done building (" .. tostring(successCount) .. "/" .. tostring(failCount + successCount) .. ")") 
end)