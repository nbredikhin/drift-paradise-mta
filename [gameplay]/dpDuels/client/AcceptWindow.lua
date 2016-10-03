AcceptWindow = {}
local screenSize = Vector2(guiGetScreenSize())
local isVisible = false
local panelWidth, panelHeight = 400, 150
local borderOffset = 15
local panelColor = {255, 255, 255}
local themeColor = {212, 0, 40}

local buttonsHeight = 50
local font, font2

local targetPlayer
local currentBet
local cancelKey = "K"
local acceptKey = "L"

local ACCEPT_TIME = 15000
local acceptTimer

local function draw()
	if not isVisible then
		return 
	end
	if not isElement(targetPlayer) then
		AcceptWindow.setVisible(false)
		return
	end
	local x = screenSize.x - panelWidth - borderOffset
	local y = borderOffset
	local alpha = 220
	dxDrawRectangle(x, y, panelWidth, panelHeight, tocolor(panelColor[1], panelColor[2], panelColor[3], alpha))
	
	local timeLeft = getTimerDetails(acceptTimer)
	timeLeft = math.floor(timeLeft / 1000)

	local str = string.format(exports.dpLang:getString("duel_accept_message"), tostring(targetPlayer.name), tostring(currentBet), tostring(timeLeft))
	dxDrawText(str, x, y, x + panelWidth, y + panelHeight - buttonsHeight, tocolor(0, 0, 0, alpha), 1, font, "center", "center", false, true)
	y = y + panelHeight - buttonsHeight
	dxDrawRectangle(x, y, panelWidth / 2, buttonsHeight, tocolor(42, 40, 41, alpha))
	str = string.format(exports.dpLang:getString("duel_accept_key_decline"), cancelKey)
	dxDrawText(str, x, y, x + panelWidth / 2, y + buttonsHeight, tocolor(255, 255, 255, alpha), 1, font2, "center", "center", false, true)
	
	dxDrawRectangle(x + panelWidth / 2, y, panelWidth / 2, buttonsHeight, tocolor(themeColor[1], themeColor[2], themeColor[3], alpha))
	str = string.format(exports.dpLang:getString("duel_accept_key_accept"), acceptKey, tostring(timeLeft))
	dxDrawText(str, x + panelWidth / 2, y, x + panelWidth, y + buttonsHeight, tocolor(255, 255, 255, alpha), 1, font2, "center", "center", false, true)
end

local function answerCall(accepted)
	AcceptWindow.setVisible(false)
	if accepted then
		triggerServerEvent("dpDuels.answerCall", resourceRoot, targetPlayer, true, currentBet)
	else
		triggerServerEvent("dpDuels.answerCall", resourceRoot, targetPlayer, false)
	end
end

local function onKey(key, state)
	if not state then 
		return
	end

	if key == string.lower(acceptKey) then
		answerCall(true)
	elseif key == string.lower(cancelKey) then
		answerCall(false)
	end
end

function AcceptWindow.setVisible(visible)
	visible = not not visible
	if visible == isVisible then
		return
	end

	if isTimer(acceptTimer) then
		killTimer(acceptTimer)
	end
	acceptTimer = nil

	if visible then
		acceptTimer = setTimer(answerCall, ACCEPT_TIME, 1, false)
		themeColor = {exports.dpUI:getThemeColor()}
		addEventHandler("onClientRender", root, draw)
		addEventHandler("onClientKey", root, onKey)
		font = exports.dpAssets:createFont("Roboto-Regular.ttf", 16)
		font2 = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)
	else
		removeEventHandler("onClientRender", root, draw)
		removeEventHandler("onClientKey", root, onKey)
		if isElement(font) then
			destroyElement(font)
		end
		if isElement(font2) then
			destroyElement(font2)
		end		
	end

	isVisible = visible
end

function AcceptWindow.show(player, bet)
	if isVisible then
		return false
	end
	if not isElement(player) then
		return false
	end
	targetPlayer = player
	currentBet = bet
	AcceptWindow.setVisible(true)
end

addEvent("dpDuels.callPlayer", true)
addEventHandler("dpDuels.callPlayer", resourceRoot, function(player, bet)
	AcceptWindow.show(player, bet)
end)