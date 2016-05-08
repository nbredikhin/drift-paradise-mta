MapWorld = {}
MapWorld.position = Vector3()

-- Текстуры
local textures = {}

function MapWorld.start()
	MapWorld.position = localPlayer.position + Vector3(0, 0, 5)
end

function MapWorld.stop()

end

local _dxDrawMaterialLine3D = dxDrawMaterialLine3D
local function dxDrawMaterialLine3D(position1, position2, material, width, color, lookAt)
	_dxDrawMaterialLine3D(position1 + MapWorld.position, position2 + MapWorld.position, material, width, color, lookAt + MapWorld.position)
end

local function drawHorizontalPlane(position, size, direction, material, color)
	direction = math.rad(direction)
	local sizeOffset = Vector3(math.cos(direction) * size.y, math.sin(direction) * size.y, 0) / 2
	dxDrawMaterialLine3D(position + sizeOffset, position - sizeOffset, material, size.x,color,position + Vector3(0, 0, 1))
end

local function drawVerticalPlane(position, size, direction, material, color)
	direction = math.rad(direction)
	local sizeOffset = Vector3(0, 0, size.y) / 2
	local lookAtOffset = Vector3(math.cos(direction) * size.y, math.sin(direction) * size.y, 0)
	dxDrawMaterialLine3D(position + sizeOffset, position - sizeOffset, material, size.x,color, position + lookAtOffset)
end

local function drawCuboid(position, size, direction, materialWall, materialTop, r, g, b)
	local rad = math.rad(direction)
	for i = 0, 3 do
		local ox, oy = math.cos(rad) * size.x / 2, math.sin(rad) * size.y / 2
		local sideSize = Vector2(size.y, size.z)
		if i == 1 or i == 3 then
			sideSize = Vector2(size.x, size.z)
		end
		local r = r * ((i + 1) / 4)
		local g = g * ((i + 1) / 4)
		local b = b * ((i + 1) / 4)
		drawVerticalPlane(position + Vector3(ox, oy, 0), sideSize, direction + 90 * i, materialWall, tocolor(r, g, b))
		rad = rad + math.pi / 2
	end
	drawHorizontalPlane(position + Vector3(0, 0, size.z / 2), size, direction + 90, materialTop, tocolor(r, g, b))	
end

function MapWorld.draw()
	drawHorizontalPlane(Vector3(0, 0, 0), Vector2(70, 70), 0, textures.fill, tocolor(50, 50, 50, 255))
	drawHorizontalPlane(Vector3(0, 0, 0), Vector2(40, 40), 90, textures.map, tocolor(255, 255, 255))
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Загрузить нужные текстуры при запуске ресурса
	textures.map = DxTexture("assets/map.png")
	textures.fill = DxTexture("assets/pixel.png")
	textures.building = DxTexture("assets/building.png")
	textures.top = DxTexture("assets/top.png")
end)