FinishScreen = {}
local isActive = false

local screenSize = Vector2(guiGetScreenSize())
local animationProgress = 0
local animationSpeed = 3

local visibleDelay = 0
local VISIBLE_TIME = 3.5

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
		FinishScreen.stop()
	end
	animationProgress = math.min(1, animationProgress + animationSpeed * dt)
	if visibleDelay < 1 / animationSpeed then
		animationProgress = visibleDelay * animationSpeed
	end
end

function FinishScreen.show(money, xp, perfectBonus, timeBonus, timePassed)
	themeColorHEX = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())

	infoText = exports.dpLang:getString("tofu_time_text") .. ": " .. themeColorHEX .. tostring(getTimeString(math.floor(timePassed)))
	mainText = exports.dpLang:getString("tofu_finish_text")
	moneyText = themeColorHEX .. "+$" .. tostring(money) .. " +" .. tostring(xp) .. " XP"
	if perfectBonus and perfectBonus > 1 then
		infoText = ("%s\n#FFFFFF+%d%% %s%s"):format(infoText, perfectBonus * 100 - 100, themeColorHEX, exports.dpLang:getString("tofu_perfect_text"))
	end
	if timeBonus and timeBonus > 1 then
		infoText = ("%s\n#FFFFFF+%d%% %s%s"):format(infoText, timeBonus * 100 - 100, themeColorHEX, exports.dpLang:getString("tofu_fast_delivery_text"))
	end

	FinishScreen.start()
end

function FinishScreen.start()
	if isActive then
		return false
	end
	isActive = true

	mainTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 52)
	moneyTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 36)
	infoTextFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 24)

	moneyTextFontHeight = dxGetFontHeight(1, mainTextFont)
	visibleDelay = VISIBLE_TIME

	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)
	return true
end

function FinishScreen.stop()
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

-- bindKey("5", "down", function() FinishScreen.show(500 * 1.1, 1223, 10) end)
