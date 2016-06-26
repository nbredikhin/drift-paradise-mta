Panel = {}
local screenWidth, screenHeight
local renderTarget
local headerColor = tocolor(29, 29, 29)
local itemColor = tocolor(42, 40, 41)
local highlightedColor = tocolor(255, 255, 255)

local panelWidth = 500
local panelHeight
local headerHeight = 50
local itemHeight = 40

local itemsCount = 10

local headerFont
local itemFont
local logoTexture
local logoWidth, logoHeight

local columns = {
	{ name = "tab_panel_column_id", 		size = 0.1, 	data = "id"},
	{ name = "tab_panel_column_nickname", 	size = 0.4, 	data = "name"},
	{ name = "tab_panel_column_money", 		size = 0.25, 	data = "money"},
	{ name = "tab_panel_column_level", 		size = 0.25, 	data = "level"},
}
local playersList = {}
local scrollOffset = 0

local function draw()
	if renderTarget then
		dxSetRenderTarget(renderTarget)
	end
	local w, h = 500, 50
	local y = screenHeight / 2 - panelHeight / 2
	local panelX = screenWidth / 2 - panelWidth / 2
	dxDrawImage(screenWidth / 2 - logoWidth / 2, y, logoWidth, logoHeight, logoTexture)
	y = y + logoHeight + 10
	dxDrawRectangle(panelX, y, panelWidth, headerHeight * 2 + itemsCount * itemHeight, headerColor)
	local x = panelX
	for i, column in ipairs(columns) do
		local width = panelWidth * column.size
		dxDrawText(exports.dpLang:getString(column.name), x, y, x + width, y + headerHeight, tocolor(255, 255, 255), 1, headerFont, "center", "center")
		x = x + width
	end
	y = y + headerHeight
	local itemY = y
	dxDrawRectangle(screenWidth / 2 - panelWidth / 2, y, panelWidth, itemsCount * itemHeight, itemColor)
	for i = scrollOffset + 1, math.min(itemsCount + scrollOffset, #playersList) do
		local player = playersList[i]
		local color = itemColor
		if i == 1 then
			color = highlightedColor
		end
		x = panelX
		dxDrawRectangle(x, y, panelWidth, itemHeight, color)
		for j, column in ipairs(columns) do
			local text = player[column.data]
			local width = panelWidth * column.size
			dxDrawText(text, x, y, x + width, y + headerHeight * 0.8, tocolor(255, 255, 255), 1, itemFont, "center", "center", true)
			x = x + width
		end
		y = y + itemHeight
	end
	x = panelX
	y = itemY + itemsCount * itemHeight
	dxDrawText("Players online: " .. tostring(#playersList), x, y, x + panelWidth, y + headerHeight, tocolor(255, 255, 255), 1, headerFont, "center", "center")
	if renderTarget then
		dxSetRenderTarget()
	end
end

local function mouseDown()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset + 1
	if scrollOffset > #playersList - itemsCount then
		scrollOffset = #playersList - itemsCount + 1
	end
end

local function mouseUp()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset - 1
	if scrollOffset < 0 then
		scrollOffset = 0
	end
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
	panelHeight = logoHeight + 10 + headerHeight * 2 + itemsCount * itemHeight
	highlightedColor = tocolor(exports.dpUI:getThemeColor())

	playersList = {}
	-- local fakePlayers = {}
	-- for i = 1, math.random(30, 50) do
	-- 	local fakePlayer = {}
	-- 	fakePlayer.name = "Kama#" .. tostring(math.random(1, 100))
	-- 	local data = {
	-- 		money = math.random(100, 999999)
	-- 	}
	-- 	function fakePlayer:getData(name)
	-- 		return data[name]
	-- 	end
	-- 	table.insert(fakePlayers, fakePlayer)
	-- end

	local function addPlayerToList(player)
		table.insert(playersList, {
			id = player:getData("serverId") or 0,
			name = exports.dpUtils:removeHexFromString(player.name),
			money = player:getData("money") or 0,
			level = 1
		})
	end
	addPlayerToList(localPlayer)
	for i, player in ipairs(getElementsByType("player")) do
		if player ~= localPlayer then
			addPlayerToList(player)
		end
	end

	bindKey("mouse_wheel_up", "down", mouseUp)
	bindKey("mouse_wheel_down", "down", mouseDown)
	localPlayer:setData("activeUI", "tabPanel")
end

function Panel.stop()
	removeEventHandler("onClientRender", root, draw)
	destroyElement(headerFont)
	destroyElement(itemFont)
	destroyElement(logoTexture)

	unbindKey("mouse_wheel_up", "down", mouseUp)
	unbindKey("mouse_wheel_down", "down", mouseDown)

	localPlayer:setData("activeUI", false)
end