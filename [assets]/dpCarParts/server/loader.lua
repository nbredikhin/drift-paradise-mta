Async:setPriority(500, 100)

local function loadPack(name, packInfo)
	local file = fileOpen("packs/dp_" .. tostring(name) .. ".bin")
	local headerLength = packInfo[1]
	file.pos = headerLength

	local txdData = file:read(packInfo[2])
	local txd = engineLoadTXD(txdData)

	local filesCount = packInfo[3]
	Async:iterate(1, filesCount, function(currentFile)
		local model = packInfo[3 + currentFile * 2 - 1]
		local size = packInfo[3 + currentFile * 2]

		engineImportTXD(txd, model)

		local dffData = file:read(size)
		local dff = engineLoadDFF(dffData)
		engineReplaceModel(dff, model)

		if currentFile == filesCount then
			file:close()
		end
	end)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	if not packs then
		outputDebugString("Failed to load car parts")
	end
	local i = 1
	for name, packInfo in pairs(packs) do
		setTimer(loadPack, 1000 * i, 1, name, packInfo)
		i = i + 1
	end
end)
