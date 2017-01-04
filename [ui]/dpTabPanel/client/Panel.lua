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
	{ name = "tab_panel_column_level", 		size = 0.25, 	data = "level"},
	{ name = "tab_panel_column_ping", 		size = 0.25, 	data = "ping"},	
}
local playersList = {}
local playersOnlineCount = 0
local playersOnlineString = "Players online"
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
		local item = playersList[i]
		local color = itemColor
		if item.isGroup then
			color = item.color
		end
		if item.isLocalPlayer then
			color = highlightedColor
		end
		x = panelX
		dxDrawRectangle(x, y, panelWidth, itemHeight, color)
		if item.isGroup then
			dxDrawText(item.text, x, y, x + panelWidth, y + headerHeight * 0.8, tocolor(255, 255, 255), 1, itemFont, "center", "center", true)
		else
			for j, column in ipairs(columns) do
				local text = item[column.data]
				local width = panelWidth * column.size
				dxDrawText(tostring(text), x, y, x + width, y + headerHeight * 0.8, tocolor(255, 255, 255), 1, itemFont, "center", "center", true)
				x = x + width
			end
		end
		y = y + itemHeight
	end
	x = panelX
	y = itemY + itemsCount * itemHeight
	dxDrawText(playersOnlineString .. ": " .. tostring(playersOnlineCount), x, y, x + panelWidth, y + headerHeight, tocolor(255, 255, 255), 1, headerFont, "center", "center")
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
	logoWidth = 280
	logoHeight = textureHeight * logoWidth / textureWidth
	panelHeight = logoHeight + 10 + headerHeight * 2 + itemsCount * itemHeight
	highlightedColor = tocolor(exports.dpUI:getThemeColor())

	playersList = {}

	local function addPlayerToList(player, isLocalPlayer)
		if type(player) == "table" then
			table.insert(playersList, player)
			return
		end
		table.insert(playersList, {
			isLocalPlayer = isLocalPlayer,
			id = player:getData("serverId") or 0,
			name = exports.dpUtils:removeHexFromString(player.name),
			ping = tostring(player.ping) .. "ms",
			level = player:getData("level") or "-"
		})
	end

	local players = getElementsByType("player")
	table.sort(players, function (player1, player2)
		local id1 = player1:getData("serverId") or 999
		local id2 = player2:getData("serverId") or 999
		return id1 < id2
	end)
	playersOnlineCount = #players

	local function getPlayersWithData(dataName)
		local t = {}
		for i = #players, 1, -1 do
			if players[i]:getData(dataName) then
				table.insert(t, table.remove(players, i))
			end
		end
		return t
	end

	addPlayerToList(localPlayer, true)
	local moderators = getPlayersWithData("group")
	if #moderators > 0 then
		addPlayerToList({ text = exports.dpLang:getString("tab_panel_group_moderators"), color = headerColor, isGroup = true} )
		for i, p in ipairs(moderators) do
			addPlayerToList(p)
		end
	end
	local premiums = getPlayersWithData("isPremium")
	if #premiums > 0 then
		addPlayerToList({ text = exports.dpLang:getString("tab_panel_group_premium"), color = headerColor, isGroup = true} )
		for i, p in ipairs(premiums) do
			addPlayerToList(p)
		end
	end

	if #players > 1 then
		addPlayerToList({ text = exports.dpLang:getString("tab_panel_group_players"), color = headerColor, isGroup = true} )
		for i, player in ipairs(players) do
			if player ~= localPlayer then
				addPlayerToList(player)
			end
		end
	end

	bindKey("mouse_wheel_up", "down", mouseUp)
	bindKey("mouse_wheel_down", "down", mouseDown)
	localPlayer:setData("activeUI", "tabPanel")

	playersOnlineString = exports.dpLang:getString("tab_panel_players_online")
	if not playersOnlineString then
		playersOnlineString = "Players online"
	end
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
