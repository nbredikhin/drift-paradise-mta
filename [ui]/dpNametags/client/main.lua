local NAMETAG_OFFSET = 1.1
local NAMETAG_WIDTH = 100
local NAMETAG_HEIGHT = 20
local NAMETAG_MAX_DISTANCE = 10
local NAMETAG_SCALE = 3

local HP_BAR_HEIGHT = 15

local nametagFont = "default"
local streamedPlayers = {}
local nametagsVisible = true

local function dxDrawNametagText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, nametagFont, "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, nametagFont, "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, nametagFont, "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, nametagFont, "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, nametagFont, "center", "center")
end

addEventHandler("onClientRender", root, function ()
	if not nametagsVisible then
		return
	end
	local r, g, b = exports.dpUI:getThemeColor()
	local cx, cy, cz = getCameraMatrix()
	for player, info in pairs(streamedPlayers) do
		local px, py, pz = getElementPosition(player)		
		local x, y = getScreenFromWorldPosition(px, py, pz + NAMETAG_OFFSET)
		if x then
			local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
			if distance < NAMETAG_MAX_DISTANCE then
				local a = 255
				local name = info.name
				local scale = 1 / distance * NAMETAG_SCALE
				local width = NAMETAG_WIDTH * scale
				local height = NAMETAG_HEIGHT * scale
				local nx, ny = x - width / 2, y - height / 2
				dxDrawNametagText(name, nx, ny, nx + width, ny + height, tocolor(r, g, b, a), scale)
				-- Отрисовка HP
				if not player.vehicle then
					local offset = height * 2.9
					dxDrawRectangle(nx - 1, ny + offset - 1, width + 2 , HP_BAR_HEIGHT * scale + 2, tocolor(0, 0, 0, 150))					
					dxDrawRectangle(nx, ny + offset, width * player.health / 100, HP_BAR_HEIGHT * scale, tocolor(r, g, b, a))
					dxDrawRectangle(nx, ny + offset, width * player.health / 100, HP_BAR_HEIGHT * scale, tocolor(r, g, b, a))
				end
			end
		end
	end
end)

local function showPlayer(player)
	if player == localPlayer then
		return
	end
	streamedPlayers[player] = {name = exports.dpUtils:removeHexFromString(player.name)}
end

addEventHandler("onClientElementStreamedIn", root, function ()
	if source.type == "player" then
		showPlayer(source)
	end
end)

addEventHandler("onClientElementStreamedOut", root, function ()
	if source.type == "player" then
		streamedPlayers[source] = false
	end
end)

addEventHandler("onClientPlayerQuit", root, function ()
	streamedPlayers[source] = false
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		if isElementStreamedIn(player) then
			showPlayer(player)
		end
	end

	-- local ped = createPed(0, Vector3{ x = 1698.612, y = -1594.151, z = 13.377})
	-- streamedPlayers[ped] = {name = "TESTPLAYER123"}
	-- ped.health = 76

	nametagFont = dxCreateFont("assets/font.ttf", 50)
end)

function setVisible(visible)
	nametagsVisible = not not visible
end