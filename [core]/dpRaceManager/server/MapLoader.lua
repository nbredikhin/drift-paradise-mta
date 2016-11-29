MapLoader = {}

function MapLoader.load(mapName)
	if type(mapName) ~= "string" then
		return false
	end
	local mapInfo = MapsList[mapName]
	if type(mapInfo) ~= "table" then
		outputDebugString("MapLoader: no such map '" .. tostring(mapName) .. "'")
		return false
	end
	local map = {}
	map.name = mapName
	map.checkpoints = {}
	map.spawnpoints = {}
	map.objects = {}
	map.duration = mapInfo.duration
	map.gamemode = mapInfo.gamemode

	-- Загрузить .map файл
	local mapPath = "maps/" .. mapName .. ".map"
	local mapXML = XML.load(mapPath)
	if not mapXML then
		outputDebugString("MapLoader: map file not found '" .. tostring(mapPath) .. "'")
		return false
	end
	-- Прочитать элементы
	for i, node in ipairs(mapXML.children) do
		local x, y, z = node:getAttribute("posX"), node:getAttribute("posY"), node:getAttribute("posZ")
		local rx, ry, rz = node:getAttribute("rotX"), node:getAttribute("rotY"), node:getAttribute("rotZ")
		if node.name == "checkpoint" then			
			table.insert(map.checkpoints, {x, y, z})
		elseif node.name == "spawnpoint" then
			table.insert(map.spawnpoints, {x, y, z, rx, ry, rz})
		elseif node.name == "object" then
			local model = node:getAttribute("model")
			table.insert(map.objects, {model, x, y, z, rx, ry, rz})
		end
	end
	return map
end

function MapLoader.createMap(checkpoints, spawnpoints, objects)
	local map = {}
	if type(checkpoints) ~= "table" or #checkpoints < 1 then
		outputDebugString("Map must have at least one checkpoint")
		return false
	end
	map.checkpoints = checkpoints
	if type(spawnpoints) ~= "table" or #spawnpoints < 1 then
		outputDebugString("Map must have at least one spawnpoint")
		return false
	end
	map.spawnpoints = spawnpoints
	if type(objects) == "table" then
		map.objects = objects
	end
	return map
end

function MapLoader.getMapStartPosition(mapName)
	if type(mapName) ~= "string" then
		return false
	end
	local mapInfo = MapsList[mapName]
	if type(mapInfo) ~= "table" then
		outputDebugString("MapLoader: no such map '" .. tostring(mapName) .. "'")
		return false
	end
	-- Загрузить .map файл
	local mapPath = "maps/" .. mapName .. ".map"
	local mapXML = XML.load(mapPath)
	if not mapXML then
		outputDebugString("MapLoader: map file not found '" .. tostring(mapPath) .. "'")
		return false
	end
	-- Прочитать элементы
	local totalX = 0
	local totalY = 0
	local totalZ = 0
	local count = 0
	for i, node in ipairs(mapXML.children) do
		if node.name == "spawnpoint" then
			local x, y, z = node:getAttribute("posX"), node:getAttribute("posY"), node:getAttribute("posZ")
			totalX = totalX + x
			totalY = totalY + y
			totalZ = totalZ + z
			count = count + 1
		end
	end
	if count == 0 then
		return false
	end
	return Vector3(totalX, totalY, totalZ) / count
end

function MapLoader.getMapsList(gamemode)
	local maps = {}
	for name, mapInfo in pairs(MapsList) do
		if not gamemode or mapInfo.gamemode == gamemode then
			maps[name] = mapInfo
		end
	end
	return maps
end