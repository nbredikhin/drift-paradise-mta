local texture = DxTexture("assets/map_buildings.png")
local pixels = texture:getPixels()
local textureSize = Vector2(texture:getSize())

local pixelsTable = {}
local currentColor = tocolor(255, 0, 0)
local currentHeight = 0.2

for x = 0, textureSize.x do
	pixelsTable[x] = {}
	for y = 0, textureSize.y do
		pixelsTable[x][y] = {tocolor(dxGetPixelColor(pixels, x, y)), false}
	end
end

local rects = {}

local function takePixel(x, y)
	return pixelsTable[x][y][1]
end

function processRect(x, y)
	local posStart = Vector2(x, y)
	local color = takePixel(x, y)
	while color == currentColor do
		x = x + 1
		color = takePixel(x, y)
	end
	x = x - 1
	color = takePixel(x, y)
	while color == currentColor do
		y = y + 1
		color = takePixel(x, y)
	end
	y = y - 1
	local posEnd = Vector2(x, y)

	for x = posStart.x, posEnd.x do
		for y = posStart.y, posEnd.y do
			pixelsTable[x][y] = {0, true}
		end
	end
	table.insert(rects, {posStart, posEnd, currentHeight})
end

local function strVector(v)
	return math.floor(v.x * 10000) / 10000 .. ", " .. math.floor(v.y * 10000) / 10000
end
addCommandHandler("doshit", function ()
	currentColor = tocolor(255, 0, 0)
	currentHeight = 0.2
	for x = 0, textureSize.x do
		for y = 0, textureSize.y do
			if pixelsTable[x][y][1] == currentColor and not pixelsTable[x][y][2] then
				processRect(x, y)
			end
		end
	end

	currentColor = tocolor(229, 255, 0)
	currentHeight = 0.6
	for x = 0, textureSize.x do
		for y = 0, textureSize.y do
			if pixelsTable[x][y][1] == currentColor and not pixelsTable[x][y][2] then
				processRect(x, y)
			end
		end
	end	

	currentColor = tocolor(0, 255, 21)
	currentHeight = 0.8
	for x = 0, textureSize.x do
		for y = 0, textureSize.y do
			if pixelsTable[x][y][1] == currentColor and not pixelsTable[x][y][2] then
				processRect(x, y)
			end
		end
	end		

	currentColor = tocolor(0, 255, 208)
	currentHeight = 1
	for x = 0, textureSize.x do
		for y = 0, textureSize.y do
			if pixelsTable[x][y][1] == currentColor and not pixelsTable[x][y][2] then
				processRect(x, y)
			end
		end
	end	
	outputChatBox("------------------------")
	for i, v in ipairs(rects) do
		local posStart = v[1] / textureSize.x
		local posEnd = v[2] / textureSize.x
		outputChatBox("{ Vector2(" .. strVector(posStart) .. "), Vector2(" .. strVector(posEnd - posStart) .. "), " .. tostring(v[3]) .."},")
	end
end)