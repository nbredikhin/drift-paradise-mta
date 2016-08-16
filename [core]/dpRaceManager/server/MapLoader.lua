MapLoader = newclass("MapLoader")

function MapLoader:init()
	self.checkpoints = {}
	self.spawnpoints = {}
	self.objects = {} 

	self.time = {12, 0}
	self.weather = 0

	self.mapName = "none"
end

function MapLoader:load(mapName)
	if type(mapName) ~= "string" then
		return false
	end
	self.mapName = mapName
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
			table.insert(self.checkpoints, {x, y, z})
		elseif node.name == "spawnpoint" then
			table.insert(self.spawnpoints, {x, y, z, rx, ry, rz})
		elseif node.name == "object" then
			local model = node:getAttribute("model")
			table.insert(self.objects, {model, x, y, z, rx, ry, rz})
		end
	end
	return true
end

function MapLoader:getMapJSON()
	return toJSON({
		objects = self.objects,
		checkpoints = self.checkpoints
	})
end