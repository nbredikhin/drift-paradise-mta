local map = DxTexture("assets/map.png")
local building = DxTexture("assets/building.png")
local pixel = DxTexture("assets/pixel.png")
local top = DxTexture("assets/top.png")

local housesList = {
	{ Vector3(1092.67, -1130.77, 22.82), Vector3(1152.61, -1109.77, 34.21) },
	{ Vector3(1103.41, -1105.83, 25.05), Vector3(1114.99, -1085.04, 36.18) },
	{ Vector3(1131.29, -1106.03, 24.81), Vector3(1142.63, -1085.4, 35.9) },
	{ Vector3(1103.68, -1076.7, 28.51), Vector3(1115.07, -1055.55, 39.59) },
	{ Vector3(1131.26, -1076.65, 28.35), Vector3(1152.44, -1051.02, 32.04) },
	{ Vector3(1172.66, -1131.87, 22.84), Vector3(1181.77, -1117.98, 30.09) },
	{ Vector3(1189.3, -1131.11, 22.9), Vector3(1252.61, -1115.61, 35.67) },
	{ Vector3(1242, -1112.85, 24.57), Vector3(1230.4, -1062.57, 39.27) },
	{ Vector3(1182.61, -1062.05, 39.39), Vector3(1194.01, -1112.15, 24.89) },
	{ Vector3(1284.77, -1053.56, 28.63), Vector3(1296.91, -1074.75, 39.38) },
	{ Vector3(1296.89, -1082.73, 35.97), Vector3(1284.46, -1104.14, 35.97) },
	{ Vector3(1314.39, -1104.59, 35.69), Vector3(1326.59, -1083.57, 35.69) },
	{ Vector3(1273.03, -1083.98, 26.09), Vector3(1326.69, -1053.9, 39.26) },
	{ Vector3(1322.04, -1182.13, 35.74), Vector3(1193.84, -1090.05, 27.36) },
	{ Vector3(1258.17, -1159.29, 41.11), Vector3(1316.91, -1171.6, 41.11) },
	{ Vector3(1321.41, -1181.7, 64.39), Vector3(1265.32, -1207.66, 93.22) },
	{ Vector3(1251.88, -1158.98, 31.71), Vector3(1225.9, -1171.93, 31.71) },
	{ Vector3(1159.17, -1161.35, 31.02), Vector3(1187.92, -1195.55, 82.9) },
	{ Vector3(1226.26, -1209.54, 35.83), Vector3(1246.74, -1177.97, 35.84) },
	{ Vector3(1294.2, -1234.92, 38.15), Vector3(1329.49, -1210.67, 38.15) },
	{ Vector3(1383.1, -1131.91, 57.39), Vector3(1424.32, -1045.4, 57.39) },
	{ Vector3(1388.52, -1019.73, 40.79), Vector3(1464.59, -978.49, 56.51) },
	{ Vector3(1469.98, -1046.12, 212.38), Vector3(1435.21, -1088.32, 212.38) },
	{ Vector3(1443.09, -1177.61, 186.14), Vector3(1368.09, -1230.96, 186.22) },
	{ Vector3(1428.16, -1149.47, 92.23), Vector3(1470.11, -1098.27, 92.38) },
	{ Vector3(1541.09, -1070.29, 180.2), Vector3(1494.15, -1104.86, 180.2) },
	{ Vector3(1491.64, -1113.83, 134.82), Vector3(1551.2, -1151.54, 134.82) },
	{ Vector3(1468.39, -1174.65, 107.29), Vector3(1499.64, -1231.45, 98.53) },
	{ Vector3(1513.75, -1279.33, 112.75), Vector3(1469.1, -1242.56, 112.77) },
	{ Vector3(1421.25, -1250.67, 34.25), Vector3(1444.54, -1322.81, 34.26) },
	{ Vector3(1444.85, -1334.85, 34.96), Vector3(1430.58, -1430.92, 34.96) },
	{ Vector3(1428.68, -1385.39, 34.96), Vector3(1367.99, -1371.55, 33.54) },
	{ Vector3(1368.73, -1370.46, 34.64), Vector3(1403.2, -1311.45, 34.64) },
	{ Vector3(1367.62, -1310.58, 32.54), Vector3(1416.84, -1251.23, 32.56) },
	{ Vector3(1332.66, -1290.72, 34.66), Vector3(1287.1, -1367.53, 34.65) },
	{ Vector3(1464.37, -1450.66, 39.59), Vector3(1495.16, -1489.65, 39.52) },
	{ Vector3(1495.26, -1483.7, 62.85), Vector3(1546.64, -1450.31, 62.85) },
	{ Vector3(1549.88, -1513.84, 66.21), Vector3(1445.48, -1578.96, 66.21) },
	{ Vector3(1463.67, -1409.9, 38.3), Vector3(1504.62, -1431.83, 34.38) },
	{ Vector3(1504.96, -1409.98, 30.46), Vector3(1544.71, -1431.93, 26.53) },
	{ Vector3(1486.13, -1409.51, 46.14), Vector3(1463.63, -1371.03, 61.83) },
	{ Vector3(1463.68, -1370.83, 162.71), Vector3(1486.01, -1331.09, 162.71) },
	{ Vector3(1523.23, -1334.98, 213.15), Vector3(1558.16, -1370.63, 328.63) },
	{ Vector3(1543.55, -1274.74, 249.65), Vector3(1597.28, -1219.09, 276.87) },
	{ Vector3(1647.75, -1215.84, 166.55), Vector3(1670.38, -1273.62, 231.7) },
	{ Vector3(1690.75, -1324.08, 107.23), Vector3(1658.55, -1356.14, 156.7) },
	{ Vector3(1700.41, -1374.31, 84.46), Vector3(1671.11, -1428.03, 83.51) },
	{ Vector3(1667.16, -1393.39, 64.46), Vector3(1634.25, -1374.48, 64.46) },
	{ Vector3(1711.52, -1451.09, 32.02), Vector3(1749.12, -1474.56, 32.02) },
	{ Vector3(1722.01, -1540.83, 32.12), Vector3(1745.48, -1560.86, 32.12) },
	{ Vector3(1740.03, -1562.13, 26.62), Vector3(1722.05, -1583.69, 26.62) },
	{ Vector3(1689.06, -1558.24, 23.53), Vector3(1704.63, -1582.5, 23.53) },
	{ Vector3(1735.39, -1428.89, 33.81), Vector3(1777.62, -1394.86, 33.81) },
	{ Vector3(1790.53, -1417.58, 28.23), Vector3(1810.82, -1354.93, 28.23) },
	{ Vector3(1817.95, -1406.41, 28.61), Vector3(1835.42, -1450.12, 34.92) },
	{ Vector3(1739.98, -1341.45, 28.98), Vector3(1816.12, -1322.31, 28.98) },
	{ Vector3(1727.43, -1388.52, 29.52), Vector3(1765.07, -1360.08, 26.41) },
	{ Vector3(1813.83, -1272.01, 130.73), Vector3(1834.15, -1317.59, 130.73) },
	{ Vector3(1774.49, -1298.03, 130.73), Vector3(1804.09, -1311.81, 130.73) },
	{ Vector3(1790.69, -1249.67, 63.56), Vector3(1830.96, -1193.45, 62.96) },
	{ Vector3(1781.08, -1159.65, 27.84), Vector3(1829.92, -1151.74, 39.48) },
	{ Vector3(1833.08, -1172.87, 39.48), Vector3(1856.37, -1120.9, 50.86) },
	{ Vector3(1856.8, -1119.37, 40.57), Vector3(1831.55, -1070.29, 40.57) },
	{ Vector3(1861.92, -1271.02, 33.27), Vector3(1903.65, -1291.6, 33.87) },
	{ Vector3(1904.47, -1270.92, 52.17), Vector3(1967.2, -1306.59, 52.17) },
	{ Vector3(1972.97, -1283.48, 36.41), Vector3(2016.6, -1298.57, 34.1) },
	{ Vector3(2037.23, -1277.98, 36.24), Vector3(2050.27, -1324.81, 36.25) },
	{ Vector3(2035.28, -1310.44, 36.25), Vector3(1968.31, -1324.55, 36.25) },
	{ Vector3(2005.49, -1359.5, 36.21), Vector3(2047.36, -1395.68, 47.33) },
	{ Vector3(2039.02, -1397.4, 66.21), Vector3(2047.1, -1406.07, 67.32) },
	{ Vector3(2049.84, -1404.44, 47.33), Vector3(2087.42, -1440.06, 47.33) },
	{ Vector3(1924.21, -1553.34, 26.56), Vector3(1914.59, -1583.54, 30.13) },
	{ Vector3(1907.63, -1595.66, 28.04), Vector3(1851.34, -1578.04, 29.41) },
	{ Vector3(1908, -1628.95, 30.96), Vector3(1839.72, -1730.64, 33.23) },
	{ Vector3(1813.03, -1740.03, 52.42), Vector3(1746.35, -1806.56, 52.37) },
	{ Vector3(1767.8, -1720.64, 33.13), Vector3(1797.46, -1706.68, 26.62) },
	{ Vector3(1767.51, -1669.9, 13.41), Vector3(1793.23, -1650.01, 38.1) },
	{ Vector3(1742.97, -1638.79, 43.39), Vector3(1711.84, -1670.53, 41.46) },
	{ Vector3(1673.28, -1658.71, 26.18), Vector3(1636.78, -1617.95, 75.21) },
	{ Vector3(1577.02, -1638.29, 27.4), Vector3(1544.37, -1713, 27.39) },
	{ Vector3(1543.25, -1757.5, 32.42), Vector3(1419.78, -1824.17, 32.42) },

	{ Vector3(1343.74, -1845.71, 40.21), Vector3(1378.28, -1827.52, 39.98) },
	{ Vector3(1322.73, -1815.38, 34.77), Vector3(1375.84, -1775.75, 35.01) },
	{ Vector3(1323.06, -1774.61, 30), Vector3(1335.76, -1742.89, 30) },
	{ Vector3(1322.41, -1682.27, 29), Vector3(1345.06, -1721.68, 30.84) },
	{ Vector3(1288.51, -1703.77, 38.75), Vector3(1212.19, -1672.9, 33.8) },
	{ Vector3(1196.93, -1649.49, 21.18), Vector3(1164.32, -1587.05, 23.71) },
	{ Vector3(1200.09, -1607.69, 21.18), Vector3(1283.1, -1586.24, 23.71) },
	{ Vector3(1229.47, -1561.66, 48.73), Vector3(1267.85, -1528.18, 49.14) },
	{ Vector3(1208.23, -1418.29, 46.25), Vector3(1233.07, -1482.8, 46.25) },
	{ Vector3(1311.16, -1459.94, 29.28), Vector3(1267.59, -1477.23, 29.27) },
	{ Vector3(1260.42, -1423.63, 26.16), Vector3(1324.49, -1438.91, 24.96) },
	{ Vector3(1184.78, -1384.1, 23.01), Vector3(1151, -1292.38, 30.51) },
	{ Vector3(1131.94, -1315.85, 24.61), Vector3(1109.72, -1292.17, 24.61) },
	{ Vector3(1135.67, -1367.78, 24.41), Vector3(1091.77, -1336.04, 19.18) },
	{ Vector3(1081.39, -1384.67, 17.67), Vector3(1074.64, -1332.52, 18.38) },
	{ Vector3(1073.04, -1329.23, 20.54), Vector3(1088.87, -1292.51, 20.54) },
	{ Vector3(1081.78, -1212.2, 20.45), Vector3(1073.21, -1270.17, 17.08) },
	{ Vector3(1083.49, -1253.69, 20.54), Vector3(1140.73, -1269.98, 20.54) },
	{ Vector3(1121.75, -1253.41, 25.53), Vector3(1140.38, -1213.66, 24.3) },
	{ Vector3(1197.35, -1250.95, 22.6), Vector3(1170.47, -1264.63, 22.6) },
	{ Vector3(1196.48, -1223.92, 25.85), Vector3(1170.5, -1237.23, 25.85) },
	{ Vector3(1243.42, -1241.24, 24.1), Vector3(1226.33, -1210.91, 24.59) },
	{ Vector3(1226.72, -1208.94, 35.83), Vector3(1245.44, -1179.81, 35.84) },
	{ Vector3(1225.94, -1171.37, 31.71), Vector3(1250.18, -1160.23, 31.71) },
	{ Vector3(1259.19, -1159.61, 40.84), Vector3(1316.77, -1170.51, 40.96) }
}

local function drawHorizontalPlane(position, size, direction, material, color)
	if not color then
		color = tocolor(255, 255, 255)
	end
	direction = math.rad(direction)
	local sizeOffset = Vector3(math.cos(direction) * size.y, math.sin(direction) * size.y, 0) / 2
	dxDrawMaterialLine3D(
		position + sizeOffset, 
		position - sizeOffset, 
		material, 
		size.x,
		color,
		position + Vector3(0, 0, 1)
	)
end

local muls = {0.1, 0.5, 1}

local function drawVerticalPlane(position, size, direction, material, color)
	if not color then
		color = tocolor(255, 255, 255)
	end	
	direction = math.rad(direction)
	local sizeOffset = Vector3(0, 0, size.y) / 2
	local lookAtOffset = Vector3(math.cos(direction) * size.y, math.sin(direction) * size.y, 0)
	dxDrawMaterialLine3D(
		position + sizeOffset, 
		position - sizeOffset, 
		material, 
		size.x,
		color,
		position + lookAtOffset
	)
end

local function drawCuboid(position, size, direction, materialWall, materialTop)
	local baseColor = math.random(100, 255)
	local rad = math.rad(direction)
	for i = 0, 3 do
		local ox, oy = math.cos(rad) * size.x / 2, math.sin(rad) * size.y / 2
		local sideSize = Vector2(size.y, size.z)
		if i == 1 or i == 3 then
			sideSize = Vector2(size.x, size.z)
		end
		local c = baseColor - i * 20
		drawVerticalPlane(position + Vector3(ox, oy, 0), sideSize, direction + 90 * i, materialWall, tocolor(c * muls[1], c * muls[2], c * muls[3]))
		rad = rad + math.pi / 2
	end
	drawHorizontalPlane(position + Vector3(0, 0, size.z / 2), size, direction + 90, materialTop, tocolor(baseColor * muls[1], baseColor * muls[2], baseColor * muls[3]))	
end

local sizeMul = 40 / 6000

local buildingsList = {}

local function makeBuilding(position1, position2)
	local startPos = Vector3()
	startPos.x = math.min(position1.x, position2.x)
	startPos.y = math.min(position1.y, position2.y)
	startPos.z = math.min(position1.z, position2.z)
	endPos = Vector3()
	endPos.x = math.max(position1.x, position2.x)
	endPos.y = math.max(position1.y, position2.y)
	endPos.z = math.max(position1.z, position2.z)	

	local position = Vector3(startPos.x, startPos.y, endPos.z / 2)
	local size = endPos - startPos
	size.z = endPos.z
	if size.z < 70 then
		return
	end
	table.insert(buildingsList, {position * sizeMul + Vector3(0, 0, 2.4), size * sizeMul})
end

for i, pos in ipairs(housesList) do
	makeBuilding(pos[1], pos[2])
end

addEventHandler("onClientRender", root, function ()
	drawHorizontalPlane(Vector3(0, 0, 2.3), Vector2(70, 70), 90, pixel, tocolor(50, 50, 50, 255))
	drawHorizontalPlane(Vector3(0, 0, 2.4), Vector2(40, 40), 90, map, tocolor(255, 255, 255))

	for i, b in ipairs(buildingsList) do
		drawCuboid(b[1], b[2], 0, building, top)
	end
end)