WinnerScreen = {}
local isActive = false

local screenSize = Vector2(guiGetScreenSize())
local animationProgress = 0
local animationSpeed = 3

local visibleDelay = 0
local VISIBLE_TIME = 4

local mainText = ""
local moneyText = ""
local infoText = ""

local mainTextFont
local moneyTextFont
local infoTextFont

local moneyTextFontHeight = 0
local themeColorHEX = "#FFAA00"

local function getTimeString(value)
	local seconds = math.floor(value)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60
	if minutes < 10 then
		minutes = "0" .. tostring(minutes)
	else
		minutes = tostring(minutes)
	end
	if seconds < 10 then
		seconds = "0" .. tostring(seconds)
	else
		seconds = tostring(seconds)
	end
	return tostring(minutes) .. ":" .. tostring(seconds)
end

local function draw()
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 200 * animationProgress))
	local scale1 = math.min(1, animationProgress * 2)
	local scale2 = math.min(1, animationProgress * 1.5)
	local scale3 = math.min(1, animationProgress * 1)
	dxDrawText(mainText, 0, 0, screenSize.x, screenSize.y / 2, tocolor(255, 255, 255, 255 * animationProgress), scale1, mainTextFont, "center", "bottom", false, false, false, true)
	dxDrawText(moneyText, 0, screenSize.y / 2, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255 * animationProgress), scale2, moneyTextFont, "center", "top", false, false, false, true)
	dxDrawText(infoText, 0, screenSize.y / 2 + moneyTextFontHeight * 0.9, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255 * animationProgress), scale3, infoTextFont, "center", "top", false, false, false, true)
end

local function update(dt)
	dt = dt / 1000

	visibleDelay = visibleDelay - dt
	if visibleDelay < 0 then
		WinnerScreen.stop()
	end
	animationProgress = math.min(1, animationProgress + animationSpeed * dt)
	if visibleDelay < 1 / animationSpeed then
		animationProgress = visibleDelay * animationSpeed
	end
end

function WinnerScreen.show(player, bet, timePassed)
	themeColorHEX = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())

	local timeString = ""
	if type(timePassed) == "number" then
		timeString = exports.dpLang:getString("duel_winner_screen_time") .. ": " .. themeColorHEX .. tostring(getTimeString(math.floor(timePassed / 1000)))
	end
	if player and player == localPlayer then
		mainText = exports.dpLang:getString("duel_winner_screen_you_won")
		moneyText = exports.dpLang:getString("duel_winner_screen_prize") .. ": " .. themeColorHEX .. "$" .. tostring(bet) 
		infoText = timeString
	elseif player and player ~= localPlayer then
		mainText = exports.dpLang:getString("duel_winner_screen_you_lost")
		moneyText = timeString
	elseif not player then
		mainText = exports.dpLang:getString("duel_winner_screen_timeout")
		moneyText = ""
	end
	WinnerScreen.start()
end

function WinnerScreen.start()
	if isActive then
		return false
	end
	isActive = true
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)

	mainTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 52)
	moneyTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 36)
	infoTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 24)

	moneyTextFontHeight = dxGetFontHeight(1, mainTextFont)
	visibleDelay = VISIBLE_TIME
	return true
end

function WinnerScreen.stop()
	if not isActive then
		return false
	end
	isActive = false
	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)

	if isElement(mainTextFont) then destroyElement(mainTextFont) end
	if isElement(moneyTextFont) then destroyElement(moneyTextFont) end
	if isElement(infoTextFont) then destroyElement(infoTextFont) end

	mainText = ""
	moneyText = ""
	infoText = ""
	return true
end

-- bindKey("5", "down", function() WinnerScreen.show(localPlayer, 500, 126123) end)

addEvent("dpDuels.showWinner", true)
addEventHandler("dpDuels.showWinner", resourceRoot, function(winner, bet, timePassed)
	WinnerScreen.show(winner, bet, timePassed)
end)