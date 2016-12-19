local packs = {
	wheels = {1494,9004960,16,1082,1304576,1085,3690496,1096,2289664,1097,1951744,1098,4151296,1077,3919872,1083,2312192,1078,2678784,1076,1073152,1084,2168832,1025,3391488,1079,991232,1075,2879488,1074,1509376,1081,1884160,1080,2469888},
	spoilers = {1525,115496,20,1000,208896,1001,92160,1002,233472,1003,174080,1023,958464,1014,765952,1015,1050624,1016,1050624,1049,471040,1050,501760,1058,440320,1060,47104,1138,186368,1139,163840,1146,1189888,1147,106496,1158,106496,1162,104448,1163,81920,1164,192512},
	exhausts = {1326,394024,10,1853,2068480,1854,61440,1855,319488,1856,137216,1857,280576,1858,399360,1859,837632,1860,1337344,1861,94208,1862,1050624},
}

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
