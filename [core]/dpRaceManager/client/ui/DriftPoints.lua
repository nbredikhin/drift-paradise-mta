DriftPoints = {}
local screenSize = Vector2(guiGetScreenSize())
local isActive = false
local FONT_SIZE = 36
local font
local listFont
local totalScore = 0
local drawScore = 0

local borderOffset = 15
local playersScoreList = {}
local scoreListUpdateTimer
local themeColor = tocolor(255, 150, 0)

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

local function getScoreText(score)
	score = tostring(score)
	local len = #score
	score = "#FFFFFF" .. score
	while len < 6 do
		score = "0" .. score
		len = len + 1
	end
	return score
end

local function draw()
	drawScore = drawScore + math.ceil((totalScore - drawScore) * 0.2) 	
	dxDrawTextShadow(exports.dpLang:getString("race_drift_score") .. ": " .. tostring(drawScore), 0, 0, screenSize.x - borderOffset, screenSize.y, tocolor(255, 255, 255), 1, font, "right", "top", 0)
	local y = 60
	for i, p in ipairs(playersScoreList) do
		local color = tocolor(255, 255, 255)
		if p[4] then
			color = themeColor
		end
		dxDrawText(p[1] .. ". " .. p[2] .. " - #AAAAAA" .. getScoreText(p[3]), 0, y, screenSize.x - borderOffset, y, color, 1, listFont, "right", "top", false, false, false, true)
		y = y + 25
	end
end

local function updateScoreList()
	local players = RaceClient.getPlayers()
	if not players then
		return
	end

    table.sort(players, function (player1, player2)
        local score1 = player1:getData("raceDriftScore") or 0
        local score2 = player2:getData("raceDriftScore") or 0
        return score1 > score2
    end)

    playersScoreList = {}
    local isFirst = trie
    for i, player in ipairs(players) do
    	if players[i + 1] and players[i + 1] == localPlayer then
    		isFirst = false
    		table.insert(playersScoreList, {i, exports.dpUtils:removeHexFromString(player.name), player:getData("raceDriftScore")})
    	elseif players[i] == localPlayer then
    		table.insert(playersScoreList, {i, exports.dpUtils:removeHexFromString(player.name), player:getData("raceDriftScore"), true})
    	elseif players[i - 1] and players[i - 1] == localPlayer then
    		table.insert(playersScoreList, {i, exports.dpUtils:removeHexFromString(player.name), player:getData("raceDriftScore")})
    	elseif isFirst and players[i - 2] and players[i - 2] == localPlayer then
    		table.insert(playersScoreList, {i, exports.dpUtils:removeHexFromString(player.name), player:getData("raceDriftScore")})
    	end
    end
end

local function earnedPoints(points)
	DriftPoints.addScore(points)
end

function DriftPoints.start()
	if isActive then
		return false
	end

	font = exports.dpAssets:createFont("Roboto-Regular.ttf", FONT_SIZE, true)
	listFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 16, true)
	isActive = true
	addEventHandler("onClientRender", root, draw)

	totalScore = 0
	drawScore = 0
	localPlayer:setData("raceDriftScore", 0)
	addEventHandler("dpDriftPoints.earnedPoints", root, earnedPoints)
	scoreListUpdateTimer = setTimer(updateScoreList, 1000, 0)

	themeColor = tocolor(exports.dpUI:getThemeColor())
end

function DriftPoints.stop()
	if not isActive then
		return false
	end

	isActive = false
	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("dpDriftPoints.earnedPoints", root, earnedPoints)
	localPlayer:setData("raceDriftScore", false)
	if isTimer(scoreListUpdateTimer) then killTimer(scoreListUpdateTimer) end
	if isElement(font) then destroyElement(font) end
	if isElement(listFont) then destroyElement(listFont) end
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


DriftPoints.start()