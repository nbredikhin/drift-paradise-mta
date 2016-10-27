DriftPoints = {}
local screenSize = Vector2(guiGetScreenSize())
local isActive = false
local FONT_SIZE = 36
local font
local totalScore = 1231232

local borderOffset = 15

addEvent("dpDriftPoints.earnedPoints")

local function dxDrawTextShadow(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, textRotation, alpha)
	if not alpha then
		alpha = 255
	end
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, false, false, false, false, false, textRotation)
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, false, false, false, false, false, textRotation)
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, false, false, false, false, false, textRotation)
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, false, false, false, false, false, textRotation)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY, false, false, false, false, false, textRotation)
end

local function draw()
	dxDrawTextShadow(exports.dpLang:getString("race_drift_score") .. ": " .. tostring(totalScore), 0, 0, screenSize.x - borderOffset, screenSize.y, tocolor(255, 255, 255), 1, font, "right", "top", 0)
end

local function earnedPoints(points)
	DriftPoints.addScore(points)
end

function DriftPoints.start()
	if isActive then
		return false
	end

	font = exports.dpAssets:createFont("Roboto-Regular.ttf", FONT_SIZE, true)
	isActive = true
	addEventHandler("onClientRender", root, draw)

	totalScore = 0
	localPlayer:setData("raceDriftScore", 0)
	addEventHandler("dpDriftPoints.earnedPoints", root, earnedPoints)
end

function DriftPoints.stop()
	if not isActive then
		return false
	end

	isActive = false
	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("dpDriftPoints.earnedPoints", root, earnedPoints)
	localPlayer:setData("raceDriftScore", false)
end

function DriftPoints.addScore(points)
	if type(points) ~= "number" then
		return false
	end
	totalScore = totalScore + points
	localPlayer:setData("raceDriftScore", totalScore)
end

function DriftPoints.getScore()
	return totalScore
end