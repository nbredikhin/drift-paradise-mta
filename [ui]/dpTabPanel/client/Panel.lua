Panel = {}
local screenWidth, screenHeight
local renderTarget 
local headerColor = tocolor(29, 29, 29)
local itemColor = tocolor(42, 40, 41)
local highlightedColor = tocolor(255, 255, 255)

local panelWidth = 500
local headerHeight = 50
local itemHeight = 40

local itemsCount = 10

local headerFont
local itemFont
local logoTexture
local logoWidth, logoHeight

local columns = {
	{ name = "#", size = 0.1, data = "id"},
	{ name = "Nickname", size = 0.5, data = "username"},
	{ name = "Money", size = 0.25, data = "money"},
	{ name = "Level", size = 0.15, data = "level"},
}

local playersList = {}
for i = 1, 300 do
	local p = {}
	local d = {
		username = "Игрок#" .. tostring(math.random(1, 300)),
		id = i + 100,
		money = math.random(10000, 1000000000),
		level = math.random(1, 100)
	}
	function p:getData(name)
		return d[name]
	end
	table.insert(playersList, p)
end

local function draw()
	dxSetRenderTarget(renderTarget)
	local w, h = 500, 50
	local y = 30
	local panelX = screenWidth / 2 - panelWidth / 2
	dxDrawImage(screenWidth / 2 - logoWidth / 2, y, logoWidth, logoHeight, logoTexture)
	y = y + logoHeight + 10
	dxDrawRectangle(panelX, y, panelWidth, headerHeight * 2 + itemsCount * itemHeight, headerColor)
	local x = panelX
	for i, column in ipairs(columns) do
		local width = panelWidth * column.size
		dxDrawText(column.name, x, y, x + width, y + headerHeight, tocolor(255, 255, 255), 1, headerFont, "center", "center")
		x = x + width
	end
	y = y + headerHeight
	local players = playersList--getElementsByType("player")
	for i = 1, math.min(itemsCount) do
		local player = players[i]
		local color = itemColor
		if i == 4 then
			color = highlightedColor
		end
		dxDrawRectangle(screenWidth / 2 - panelWidth / 2, y, panelWidth, itemHeight, color)
		x = panelX
		for j, column in ipairs(columns) do
			local text = player:getData(column.data)
			local width = panelWidth * column.size
			dxDrawText(text, x, y, x + width, y + headerHeight * 0.8, tocolor(255, 255, 255), 1, itemFont, "center", "center", true)
			x = x + width
		end		
		y = y + itemHeight
	end
	x = panelX
	dxDrawText("Players online: 999", x, y, x + panelWidth, y + headerHeight, tocolor(255, 255, 255), 1, headerFont, "center", "center")
	dxSetRenderTarget()
end

function Panel.start()
	renderTarget = exports.dpUI:getRenderTarget()
	screenWidth, screenHeight = exports.dpUI:getScreenSize()
	addEventHandler("onClientRender", root, draw)
	headerFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 18)
	itemFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)
	logoTexture = exports.dpAssets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(logoTexture)
	logoWidth = 415
	logoHeight = textureHeight * 415 / textureWidth	
	highlightedColor = tocolor(exports.dpUI:getThemeColor())
end

function Panel.stop()
	removeEventHandler("onClientRender", root, draw)
	destroyElement(headerFont)
	destroyElement(itemFont)
	destroyElement(logoTexture)
end