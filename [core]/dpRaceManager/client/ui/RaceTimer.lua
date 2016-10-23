RaceTimer = {}
RaceTimer.isActive = false

local screenSize = Vector2(guiGetScreenSize())
local panelWidth = 200
local panelHeight = 40

local fadeProgress = 0
local font
local themeColor = {0, 0, 0}
local timeIcon

local raceTimeLeft = 0

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
	local x = screenSize.x / 2 - panelWidth / 2
	local xInit = x
	local y = 0
	dxDrawRectangle(x, y, panelWidth, panelHeight, tocolor(29, 29, 29, 220 * fadeProgress))
	local whiteColor = tocolor(255, 255, 255, 255 * fadeProgress)
	local primaryColor = tocolor(themeColor[1], themeColor[2], themeColor[3], 255 * fadeProgress)

	local posText = "Pos"
	local posTextWidth = dxGetTextWidth(posText, 1, font, false)
	x = x + 5
	dxDrawText(posText, x, y, x + posTextWidth, y + panelHeight, whiteColor, 1, font, "left", "center")
	x = x + posTextWidth + 5

	local posValueText = tostring(RaceClient.gamemode.rank) .. "/" .. tostring(#RaceClient.getPlayers())
	local posValueTextWidth = dxGetTextWidth(posValueText, 1, font, false)
	dxDrawText(posValueText, x, y, x + posTextWidth, y + panelHeight, primaryColor, 1, font, "left", "center") 
	x = x + posValueTextWidth + 10

	local cpText = "CP"
	local cpTextWidth = dxGetTextWidth(cpText, 1, font, false)
	dxDrawText(cpText, x, y, x + posTextWidth, y + panelHeight, whiteColor, 1, font, "left", "center") 
	x = x + cpTextWidth + 5	
	local currentCheckpoint = RaceCheckpoints.getCurrentCheckpoint()
	local totalCheckpoints = RaceCheckpoints.getCheckpointsCount()
	local cpValueText = tostring(currentCheckpoint) .. "/" .. tostring(totalCheckpoints)
	local cpValueTextWidth = dxGetTextWidth(cpValueText, 1, font, false)
	dxDrawText(cpValueText, x, y, x + posTextWidth, y + panelHeight, primaryColor, 1, font, "left", "center") 
	x = x + cpValueTextWidth + 10

	local timeSize = 16
	dxDrawImage(x, y + panelHeight / 2 - timeSize / 2, timeSize, timeSize, timeIcon, 0, 0, 0, whiteColor)
	x = x + timeSize + 5	
	local timeLeftText = tostring(getTimeString(raceTimeLeft))
	local timeLeftTextWidth = dxGetTextWidth(timeLeftText, 1, font, false)
	dxDrawText(timeLeftText, x, y, x + posTextWidth, y + panelHeight, primaryColor, 1, font, "left", "center") 
	x = x + timeLeftTextWidth + 5	
	panelWidth = x - xInit
end

local function update(dt)
	dt = dt / 1000
	fadeProgress = math.min(1, fadeProgress + dt)
	raceTimeLeft = math.max(0, raceTimeLeft - dt)
end

function RaceTimer.start()
	if RaceTimer.isActive then
		return false
	end
	RaceTimer.isActive = true

	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)

	fadeProgress = 0
	font = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)
	themeColor = {exports.dpUI:getThemeColor()}
	timeIcon = dxCreateTexture("assets/timer.png")
	
	raceTimeLeft = RaceClient.settings.duration
end

function RaceTimer.setTimeLeft(time)
	if not RaceTimer.isActive then
		return false
	end	
	if type(time) ~= "number" then
		return false
	end
	raceTimeLeft = time
end

function RaceTimer.stop()
	if not RaceTimer.isActive then
		return false
	end
	RaceTimer.isActive = false

	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)

	if isElement(font) then destroyElement(font) end
	if isElement(timeIcon) then destroyElement(timeIcon) end
end