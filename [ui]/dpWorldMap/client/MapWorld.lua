MapWorld = {}
MapWorld.position = Vector3()
local MAP_SIZE = 40
local buildingAlpha = 0

-- Текстуры
local textures = {}

function MapWorld.start()
	MapWorld.position = Vector3(localPlayer.position) + Vector3(0, 0, 5)
end

function MapWorld.stop()

end

function MapWorld.getMapFromWorldPosition(position, y, z)
	if type(position) == "number" and y and z then
		local x = position
		return x / 6000 * MAP_SIZE, y / 6000 * MAP_SIZE, z / 6000 * MAP_SIZE
	else
		return position / 6000 * MAP_SIZE
	end
end

function MapWorld.convertPositionToMap(x, y, z)
	return MapWorld.position.x + x / 6000 * MAP_SIZE, MapWorld.position.y + y / 6000 * MAP_SIZE, MapWorld.position.z + z / 6000 * MAP_SIZE
end

local _dxDrawMaterialLine3D = dxDrawMaterialLine3D
local function dxDrawMaterialLine3D(x1, y1, z1, x2, y2, z2, material, width, color, lx, ly, lz)	
	_dxDrawMaterialLine3D(
		x1 + MapWorld.position.x, 
		y1 + MapWorld.position.y, 
		z1 + MapWorld.position.z, 
		x2 + MapWorld.position.x, 
		y2 + MapWorld.position.y, 
		z2 + MapWorld.position.z, 
		material, 
		width, 
		color, 
		lx + MapWorld.position.x,
		ly + MapWorld.position.y,
		lz + MapWorld.position.z
	)
end

local function drawHorizontalPlane(x, y, z, sx, sy, direction, material, color)
	direction = math.rad(direction)
	local ox, oy = math.cos(direction) * sy / 2, math.sin(direction) * sy / 2
	dxDrawMaterialLine3D(
		x + ox,
		y + oy,
		z,
		x - ox,
		y - oy,
		z, 
		material, 
		sx,
		color,
		x, 
		y,
		z + 1
	)
end

local function drawVerticalPlane(x, y, z, sx, sy, direction, material, color)
	direction = math.rad(direction)
	local oz = sy / 2
	local lx, ly = math.cos(direction) * sy, math.sin(direction) * sy
	dxDrawMaterialLine3D(
		x, y, z + oz, 
		x, y, z - oz, 
		material, 
		sx,
		color, 
		x + lx,
		y + ly,
		z
	)
end

local function drawCuboid(x, y, z, sx, sy, sz, direction, materialWall, materialTop, r, g, b, a)
	local rad = math.rad(direction)
	for i = 0, 3 do
		local ox, oy = math.cos(rad) * sx / 2, math.sin(rad) * sy / 2
		local sideSizeX, sideSizeY = sy, sz
		if i == 1 or i == 3 then
			sideSizeX, sideSizeY = sx, sz
		end
		local r = r * ((i + 1) / 4)
		local g = g * ((i + 1) / 4)
		local b = b * ((i + 1) / 4)
		drawVerticalPlane(
			x + ox,
			y + oy,
			z, 
			sideSizeX,
			sideSizeY, 
			direction + 90 * i, 
			materialWall, 
			tocolor(r, g, b, a)
		)
		rad = rad + math.pi / 2
	end
	drawHorizontalPlane(
		x,
		y,
		z + sz / 2,
		sx, sy, 
		direction + 90, 
		materialTop, 
		tocolor(r, g, b, a)
	)	
end

local function drawBuilding(building)
	local height = building[3]
	if not height then
		height = 0.2
	end
	local sx, sy = building[2].x * MAP_SIZE, building[2].y * MAP_SIZE
	local x, y, z = building[1].x * MAP_SIZE + sx / 2, building[1].y * MAP_SIZE + sy / 2, height / 2 + 0.01
	x = x - MAP_SIZE / 2
	y = (y - MAP_SIZE / 2) * -1
	drawCuboid(x, y, z, sx, sy, height, 0, textures.building, textures.top, building[4], building[4], building[4], buildingAlpha)
end

function MapWorld.update()
	drawHorizontalPlane(0, 0, -0.1, MAP_SIZE * 1.5, MAP_SIZE * 1.5, 0, textures.fill, tocolor(50, 50, 50, 255))
	drawHorizontalPlane(0, 0, 0, MAP_SIZE, MAP_SIZE, 90, textures.map, tocolor(255, 255, 255))

	if MapCamera.getHeight() < 12 then
		buildingAlpha = math.min(255, (1 - (MapCamera.getHeight() - 5) / 7) * 255)
		for i, building in ipairs(buildingsTable) do
			drawBuilding(building)
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Загрузить нужные текстуры при запуске ресурса
	textures.map = DxTexture("assets/map.png")
	textures.fill = DxTexture("assets/pixel.png")
	textures.building = DxTexture("assets/building.png")
	textures.top = DxTexture("assets/top.png")
end)

MapWorld.drawHorizontalPlane = drawHorizontalPlane
MapWorld.drawMaterialLine3D = dxDrawMaterialLine3D
MapWorld.drawVerticalPlane = drawVerticalPlane