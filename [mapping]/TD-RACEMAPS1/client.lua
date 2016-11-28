local res = "Pista-58EbM457541" -- Название ресурса
local tex = "ebisuland.txd" -- текстура
local LODDistance = 299 -- дистанция прорисовки
local mapObj = {}

local objTable = {
	-- [NUM] = {"имя дфф (и кол)", ID, X, Y, Z}
	[1] = {"ebisu01", 1940, 2608.22, 72.903, 931.726},
	[2] = {"ebisu02", 1941, 2264.602, -276.338, 977.4},
	[3] = {"ebisu03", 1942, 2201.105, -84.995, 941.89},
	[4] = {"ebisu04", 1943, 2209.695, 230.098, 950.816},
	[5] = {"ebisu05", 1944, 1870.261, 210.621, 975.711},
	[6] = {"ebisu06", 1945, 1874.586, -204.049, 982.652},
	[7] = {"ebisu07", 1947, 1611.559, 136.625, 1009.915},
	[8] = {"ebisu08", 1948, 1623.84, -153.902, 994.142},
	[9] = {"ebisu09", 1952, 2206.47, 15.978, 945.516},
	[10] = {"ebisu10", 1953, 2080.242, -10.524, 947.446},
	[11] = {"ebisu11", 1955, 1954.028, -28.45, 949.775},
	[12] = {"ebisu12", 1956, 1824.541, -34.943, 956.915},
	[13] = {"ebisu13", 1978, 1712.956, -114.153, 972.844},
	[14] = {"ebisu14", 1979, 1599.691, -141.733, 993.947},
	[15] = {"ebisu15", 2188, 1663.628, 49.598, 983.918},
	[16] = {"ebisu16", 2189, 2146.972, 31.777, 950.599},
	[17] = {"ebisu17", 2324, 2103.582, -62.32, 949.209},
	[18] = {"ebisu18", 2325, 2016.334, 15.479, 948.232},
	[19] = {"ebisu19", 2326, 1898.383, 8.18, 950.895},
	[20] = {"ebisu20", 2327, 1722.734, -89.665, 966.674},
	[21] = {"ebisu21", 2348, 1984.123, -35.36, 954.383},
	[22] = {"ebisu22", 2349, 2108.736, -19.395, 951.657},
	[23] = {"ebisu23", 2618, 2198.88, 53.969, 950.453},
	[24] = {"ebisu24", 2640, 2160.926, -6.619, 952.287},
	[25] = {"ebisu25", 2681, 2005.126, -26.606, 952.247},
	[26] = {"ebisu26", 2754, 1860.831, -33.985, 958.127},
	[27] = {"ebisu27", 2778, 1680.065, -124.561, 989.299},
	[28] = {"ebisu28", 2779, 1678.683, 46.915, 987.326},
	[29] = {"ebisu29", 2783, 2215.375, 53.821, 948.729}
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	local txd = engineLoadTXD(tex, true)
	for i = 1, #objTable do
		
		engineImportTXD(txd, objTable[i][2])
		local col = engineLoadCOL(objTable[i][1]..".col")
		engineReplaceCOL(col, objTable[i][2])
		local dff = engineLoadDFF(objTable[i][1]..".dff")
		engineReplaceModel(dff, objTable[i][2])
		engineSetModelLODDistance(objTable[i][2], LODDistance)

		mapObj[i] = createObject(objTable[i][2], objTable[i][3], objTable[i][4], objTable[i][5])
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	for i = 1, #objTable do 
		destroyElement(mapObj[i])
	end
end)