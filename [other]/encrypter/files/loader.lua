local loadFromRAM = true

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

local function loadModel(model, fileName, headerLength, dffLength, txdLength)
	local file = fileOpen(fileName)
	if not file then
		return
	end

	file.pos = headerLength
	local dffData = file:read(dffLength)
	local txdData = file:read(txdLength)

	-- TXD
	local txd
	if not loadFromRAM then
		txd = engineLoadTXD(txdData)
	else
		saveFile("tmp", txdData)
		txd = engineLoadTXD("tmp")				
	end
	if txd then		
		engineImportTXD(txd, model)
	end

	-- DFF
	local dff
	if loadFromRAM then
		dff = engineLoadDFF(dffData)
	else
		saveFile("tmp", dffData)
		dff = engineLoadDFF("tmp")
	end
	if dff then
		engineReplaceModel(dff, model)
	end

	if fileExists("tmp") then
		fileDelete("tmp")
	end
	file:close()
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	if not VEHICLES_LIST then
		return
	end

	engineSetAsynchronousLoading(false, false) 

	for i, info in ipairs(VEHICLES_LIST) do
		loadModel(unpack(info))
	end
end)

