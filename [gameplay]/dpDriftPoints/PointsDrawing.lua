PointsDrawing = {}
local screenSize = Vector2(guiGetScreenSize())
local font
local FONT_SIZE = 70
local TEXT_COLOR = {255, 255, 255}
local FUCKED_UP_TEXT_COLOR = {255, 0, 0}
local CLOSE_TEXT_COLOR = {255, 150, 0}
local SHADOW_COLOR = tocolor(0, 0, 0, 150)
local SHADOW_OFFSET = Vector2(2, 2)
local TEXT_VERTICAL_OFFSET = screenSize.y / 3
local PULSE_MUL = 0.1

function PointsDrawing.draw(driftPoints, pointsMultiplier)
	local color = TEXT_COLOR
	if DriftPoints.isDriftingClose() then
		color = CLOSE_TEXT_COLOR 
	end
	if DriftPoints.isPreventedByCollision() then
		color = FUCKED_UP_TEXT_COLOR
	end
	color = tocolor(unpack(color))
	local scaleMul = math.max(0.5, math.min(1, driftPoints / 5000))
	local scale = scaleMul
	if DriftPoints.isDrifting() then
		scale = (1 - (math.sin(getTickCount() / 100) + 1) * PULSE_MUL * scaleMul) * scaleMul
	end
	dxDrawText(
		tostring(driftPoints), 
		SHADOW_OFFSET.x, 
		SHADOW_OFFSET.y, 
		screenSize.x + SHADOW_OFFSET.x, 
		screenSize.y / 3 + SHADOW_OFFSET.y,
		SHADOW_COLOR, 
		scale, 
		font,
		"center", 
		"center"
	)
	dxDrawText(tostring(driftPoints), 0, 0, screenSize.x, screenSize.y / 3, color, scale, font, "center", "center")
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	font = exports.dpAssets:createFont("Cuprum-Bold.ttf", FONT_SIZE)
end)