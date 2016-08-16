-- Экран гонки
RaceScreen = Screen:subclass("RaceScreen")
local screenSize = Vector2(guiGetScreenSize())
local raceTimeLeft = 0
local panelWidth = 200
local panelHeight = 40

function RaceScreen:init()
	self.super:init()

	raceTimeLeft = Race.settings.duration
	self.font = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)
	self.themeColor = {exports.dpUI:getThemeColor()}
	self.timeIcon = dxCreateTexture("assets/timer.png")
end

function RaceScreen:hide()
	self.super:hide()
	if isElement(self.font) then
		destroyElement(self.font)
	end
end

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

function RaceScreen:draw()
	self.super:draw()
	local x = screenSize.x / 2 - panelWidth / 2
	local xInit = x
	local y = 0
	dxDrawRectangle(x, y, panelWidth, panelHeight, tocolor(29, 29, 29, 220 * self.fadeProgress))
	local whiteColor = tocolor(255, 255, 255, 255 * self.fadeProgress)
	local primaryColor = tocolor(self.themeColor[1], self.themeColor[2], self.themeColor[3], 255 * self.fadeProgress)

	local posText = "Pos"
	local posTextWidth = dxGetTextWidth(posText, 1, self.font, false)
	x = x + 5
	dxDrawText(posText, x, y, x + posTextWidth, y + panelHeight, whiteColor, 1, self.font, "left", "center")
	x = x + posTextWidth + 5

	local posValueText = "99/99"
	local posValueTextWidth = dxGetTextWidth(posValueText, 1, self.font, false)
	dxDrawText(posValueText, x, y, x + posTextWidth, y + panelHeight, primaryColor, 1, self.font, "left", "center") 
	x = x + posValueTextWidth + 10

	local cpText = "CP"
	local cpTextWidth = dxGetTextWidth(cpText, 1, self.font, false)
	dxDrawText(cpText, x, y, x + posTextWidth, y + panelHeight, whiteColor, 1, self.font, "left", "center") 
	x = x + cpTextWidth + 5	
	local cpValueText = "98/99"
	local cpValueTextWidth = dxGetTextWidth(cpValueText, 1, self.font, false)
	dxDrawText(cpValueText, x, y, x + posTextWidth, y + panelHeight, primaryColor, 1, self.font, "left", "center") 
	x = x + cpValueTextWidth + 10

	local timeSize = 16
	dxDrawImage(x, y + panelHeight / 2 - timeSize / 2, timeSize, timeSize, self.timeIcon, 0, 0, 0, whiteColor)
	x = x + timeSize + 5	
	local timeLeftText = tostring(getTimeString(raceTimeLeft))
	local timeLeftTextWidth = dxGetTextWidth(timeLeftText, 1, self.font, false)
	dxDrawText(timeLeftText, x, y, x + posTextWidth, y + panelHeight, primaryColor, 1, self.font, "left", "center") 
	x = x + timeLeftTextWidth + 5	
	panelWidth = x - xInit
end

function RaceScreen:update(dt)
	self.super:update(dt)

	raceTimeLeft = raceTimeLeft - dt
end