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