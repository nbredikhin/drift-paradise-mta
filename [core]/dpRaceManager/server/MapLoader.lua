MapLoader = {}

function MapLoader.load(mapName)
	if type(mapName) ~= "string" then
		return false
	end
	local map = {}
	map.name = mapName
	map.checkpoints = {}
	map.spawnpoints = {}
	map.objects = {}

	-- Загрузить .map файл
	local mapXML = XML.load("maps/" .. mapName .. ".map")
	if not mapXML then
		outputDebugString("MapLoader: no such map '" .. tostring(mapName) .. "'")
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

function MapLoader.createMap(gamemode, checkpoints, spawnpoints, objects)
	local map = {}
	if type(gamemode) ~= "string" then
		gamemode = "default"
	end
	map.gamemode = gamemode
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
	return true
end