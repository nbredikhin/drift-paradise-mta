WinnerScreen = {}
local isActive = false

local screenSize = Vector2(guiGetScreenSize())
local animationProgress = 0
local animationSpeed = 3

local visibleDelay = 0
local VISIBLE_TIME = 4

local mainText = ""
local infoText = ""

local mainTextFont
local infoTextFont

local function draw()
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150 * animationProgress))
	dxDrawText(mainText, 0, 0, screenSize.x, screenSize.y / 2, tocolor(255, 255, 255, 255 * animationProgress), 1, mainTextFont, "center", "bottom")
	dxDrawText(infoText, 0, screenSize.y / 2, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255 * animationProgress), 1, infoTextFont, "center", "top")
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

function WinnerScreen.show(player, bet)
	if player == localPlayer then
		mainText = "Вы победили!"
		infoText = "Выигрыш: $" .. tostring(bet) 
	else
		mainText = "Вы проиграли!"
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

	mainTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 48)
	infoTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 36)

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
	if isElement(infoTextFont) then destroyElement(infoTextFont) end

	mainText = ""
	infoText = ""
	return true
end

bindKey("5", "down", function() WinnerScreen.show(localPlayer, 500) end)

addEvent("dpDuels.showWinner", true)
addEventHandler("dpDuels.showWinner", resourceRoot, function(winner, bet)
	if not isElement(winner) then
		return
	end
	WinnerScreen.show(winner, bet)
end)