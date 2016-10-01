local screenSize = Vector2(guiGetScreenSize())
local themeColor = {212, 0, 40}
local font

local SWITCHING_TIME = 2

local BAR_WIDTH = 400
local BAR_HEIGHT = 30

local switchingDelay = 0
local isSwitching = false

local drawProgress = true
local text = ""

local function draw()
	local progress = 1 - switchingDelay / SWITCHING_TIME

	local alpha = 1
	if progress < 0.1 then
		alpha = progress / 0.1
	elseif progress > 0.9 then
		alpha = 1 - (progress - 0.9) / 0.1
	end

	local x = (screenSize.x - BAR_WIDTH) / 2
	local y = (screenSize.y - BAR_HEIGHT) * 0.9
	if drawProgress then
		--dxDrawRectangle(x - 15, y - 40, BAR_WIDTH + 30, BAR_HEIGHT + 55, tocolor(40, 42, 41, 255 * alpha))
		dxDrawRectangle(x, y, BAR_WIDTH, BAR_HEIGHT, tocolor(20, 20, 20, 255 * alpha))
		dxDrawRectangle(x, y, BAR_WIDTH * progress, BAR_HEIGHT, tocolor(themeColor[1], themeColor[2], themeColor[3], 255 * alpha))
	end
	dxDrawText(text, x - 1, y - 6, x - 1 + BAR_WIDTH, y - 5, tocolor(0, 0, 0, 150 * alpha), 1, font, "center", "bottom")
	dxDrawText(text, x + 1, y - 6, x + 0 + BAR_WIDTH, y - 5, tocolor(0, 0, 0, 150 * alpha), 1, font, "center", "bottom")
	dxDrawText(text, x, y - 6 - 1, x + BAR_WIDTH, y - 5 - 1, tocolor(0, 0, 0, 150 * alpha), 1, font, "center", "bottom")
	dxDrawText(text, x, y - 6 + 1, x + BAR_WIDTH, y - 5 + 1, tocolor(0, 0, 0, 150 * alpha), 1, font, "center", "bottom")

	local textColor = {255, 255, 255}
	if not drawProgress then
		textColor = {unpack(themeColor)}
	end
	dxDrawText(text, x, y - 6, x + BAR_WIDTH, y - 5, tocolor(textColor[1], textColor[2], textColor[3], 255 * alpha), 1, font, "center", "bottom")
end

local function update(dt)
	dt = dt / 1000

	switchingDelay = switchingDelay - dt
	if switchingDelay < 0 then
		stopSwitching()
		switchHandlingInstantly()
	end

	if drawProgress and (getControlState("accelerate") or getControlState("brake_reverse")) then
		stopSwitching()
		switchHandling()
	end
end

function stopSwitching()
	if not isSwitching then
		return 
	end
	isSwitching = false

	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)	
end

function switchHandling()
	if isSwitching then
		stopSwitching()
		return
	end
	isSwitching = true

	switchingDelay = SWITCHING_TIME
	themeColor = {exports.dpUI:getThemeColor()}
	font = exports.dpAssets:createFont("Roboto-Regular.ttf", 22),

	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)

	drawProgress = true
	if localPlayer.vehicle.velocity:getLength() > 0.001 then
		drawProgress = false
		text = exports.dpLang:getString("handling_switching_message_moving")
	else
		if localPlayer.vehicle:getData("activeHandling") == "street" then
			if localPlayer.vehicle:getData("DriftHandling") == 0 then
				text = exports.dpLang:getString("handling_switching_message_no_upgrade")
				drawProgress = false
			else
				text = exports.dpLang:getString("handling_switching_message_drift")
			end
		else
			text = exports.dpLang:getString("handling_switching_message_street")
		end
	end

	BAR_WIDTH = dxGetTextWidth(text, 1, font) + 40
end

function switchHandlingInstantly()
	triggerServerEvent("switchPlayerHandling", resourceRoot)
end

bindKey("2", "down", function ()
	if not localPlayer.vehicle then
		return 
	end
	switchHandling()
end)