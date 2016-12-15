local LUAC_URL = "http://luac.mtasa.com/?compile=1&debug=0&obfuscate=1"
local config = {}
local compileDone = 0
local compileTotal = 0

local moduleStart = "(function()\n"
local moduleEnd = "\nend)();\n\n"

local function compileScript(path)
    compileTotal = compileTotal + 1
    local data = loadFile(path)
    fetchRemote(LUAC_URL, function (data, err)
        if not data or err > 0 then
            return
        end
        saveFile(path, data)
        compileDone = compileDone + 1
        if compileDone >= compileTotal then
            print("Compiled all scripts")
        else
            print("Progress: " .. math.floor(compileDone / compileTotal * 100) .. "%")
        end
    end, data, false)
end

local function isPathExcluded(path)
    return underscore.any(config.pathEncryptExclude, function (pattern)
        return not not string.find(path, pattern, 1, true)
    end)
end

local function processResource(resource)
    local resourcePath = ":" .. resource.name .. "/"
    local resourceMeta = XML.load(resourcePath .. "meta.xml")
    if not resourceMeta then
        print("Failed to open resource '" .. tostring(resource.name) .. "'")
        return
    end

    local concatScripts = {
        client = "",
        server = "",
        shared = ""
    }

    local buildPath = "build/" .. resource.name .. "/"
    if config.enablePathEncrypt then
        concatScripts.shared = concatScripts.shared .. "_exclude_paths=" .. arrayToString(config.pathEncryptExclude) .. ";\n"
        concatScripts.shared = concatScripts.shared .. loadFile("files/path_decrypt.lua") .. "\n\n"
    end
    if config.enableExportEncrypt then
        buildPath = "build/" .. md5(resource.name) .. "/"
        concatScripts.shared = concatScripts.shared .. loadFile("files/export_decrypt.lua") .. "\n\n"
    end
    local buildMeta = XML(buildPath .. "meta.xml", "meta")

    local resourceHasClientFiles = false
    underscore.each(resourceMeta.children, function (child)
        if child.name == "script" then
            local scriptType = child:getAttribute("type")
            local scriptPath = child:getAttribute("src")
            local scriptData = loadFile(resourcePath .. scriptPath)
            concatScripts[scriptType] = concatScripts[scriptType]
                .. "-- " .. scriptPath .. "\n"
                .. moduleStart
                .. scriptData
                .. moduleEnd
        else
            local buildChild = buildMeta:createChild(child.name)
            buildChild.value = child.value
            for name, value in pairs(child.attributes) do
                buildChild:setAttribute(name, value)
            end
            local sourcePath = buildChild:getAttribute("src")
            if sourcePath then
                local targetPath = sourcePath
                if config.enableShaderCache == false and sourcePath:find(".fx") then
                    buildChild:setAttribute("cache", "false")
                end
                if config.enablePathEncrypt then
                    if isPathExcluded(sourcePath) then
                        -- Переместить шейдеры в корень
                        if sourcePath:find(".fx") then
                            targetPath = sourcePath:match(".+/(.+)")
                            if not targetPath then
                                targetPath = sourcePath
                            end
                        end
                    else
                        targetPath = md5("dp" .. sourcePath)
                    end
                    buildChild:setAttribute("src", targetPath)
                end
                copyFile(resourcePath .. sourcePath, buildPath .. targetPath)
            end
            if child.name == "file" then
                resourceHasClientFiles = true
            end
            if config.enableExportEncrypt and child.name == "include" then
                local name = buildChild:getAttribute("resource")
                if name then
                    buildChild:setAttribute("resource", md5(name))
                end
            end
        end
    end)
    resourceMeta:unload()

    local scriptsIncludeOrder = {"shared", "server", "client"}
    underscore.each(scriptsIncludeOrder, function(type)
        local data = concatScripts[type]
        if #data > 0 then
            local child = buildMeta:createChild("script")
            local filename = tostring(type) .. ".bin"
            if config.enablePathEncrypt then
                filename = md5("dp" .. tostring(type)) .. ".bin"
            end
            child:setAttribute("src", filename)
            child:setAttribute("type", type)
            child:setAttribute("cache", tostring(not not config.enableScriptCache))
            saveFile(buildPath .. filename, data)

            if config.enableCompilation then
                compileScript(buildPath .. filename)
            end
        end
    end)
    -- Readme
    if config.enableReadmeFiles then
        copyFile("files/readme.txt", buildPath .. "readme.txt")
        if resourceHasClientFiles then
            local child = buildMeta:createChild("file")
            child:setAttribute("src", "readme.txt")
        end
    end
    buildMeta:saveFile()
    buildMeta:unload()
end

addCommandHandler("build", function ()
    print("Start building...")
    compileDone = 0
    compileTotal = 0
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
    local resources = getResources()
    config.only = config.only or {}
    config.include = config.include or {}
    config.pathEncryptExclude = config.pathEncryptExclude or {}
    -- Если не задан список ресурсов, которые нужно собрать - собрать всё
    if not config.only or #config.only == 0 then
        config.resourcePrefix = config.resourcePrefix or "dp"
        print("Build all resources with prefix '" .. config.resourcePrefix .. "'")
        resources = underscore.filter(resources, function (resource)
            return
                resource.name:sub(1, #config.resourcePrefix) == config.resourcePrefix
                or underscore.include(config.include, resource.name)
        end)
    else
        print("Build only " .. #config.only .. " resource(s) from config")
        resources = underscore.filter(resources, function (resource)
            return underscore.include(config.only, resource.name)
        end)
    end
    print("Found " .. #resources .. " resource(s) to build")
    print("Building...")
    underscore.each(resources, processResource)
    print("Done building")
    if config.enableCompilation then
        print("Compiling " .. compileTotal .. " scripts...")
    end
end)
