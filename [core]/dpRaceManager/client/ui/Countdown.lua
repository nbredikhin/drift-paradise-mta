Countdown = {}
local isVisible = false
local screenSize = Vector2(guiGetScreenSize())
local value = 3
local countdownSize = 200
local countdownTextures = {}
local timer
local animationProgress = 0


local function draw()
	if not isVisible then
		return false
	end

	local size = countdownSize + animationProgress * 20
	dxDrawImage(
		(screenSize.x - size) / 2, 
		(screenSize.y - size) / 2, 
		size, 
		size, 
		countdownTextures[value],
		0, 0, 0,
		tocolor(255, 255, 255, math.max(0, 255 - 255 * animationProgress))
	) 
end

local function update(dt)
	if not isVisible then
		return false
	end
	animationProgress = animationProgress + dt
end

function Countdown.start()
	if isVisible then
		return
	end
	value = 4

	countdownTextures = {}
	for i = 1, 4 do
		countdownTextures[i] = dxCreateTexture("assets/countdown" .. tostring(i - 1) .. ".png")
	end

	if isTimer(timer) then
		killTimer(timer)
	end
	animationProgress = 0
	timer = setTimer(function()
		value = value - 1
		if value == 3 or value == 2 then
			playSoundFrontEnd(44)
		elseif value == 1 then
			playSoundFrontEnd(45)
		end
		animationProgress = 0
		if value < 1 then
			value = 1
			Countdown.stop()
		end	
	end, 1000, 4)
	playSoundFrontEnd(44)
	isVisible = true

	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)
end

function Countdown.stop()
	if not isVisible then
		return false
	end
	isVisible = false

	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)

	for i = 0, 3 do
		if isElement(countdownTextures[i]) then
			destroyElement(countdownTextures[i])
		end
	end
	countdownTextures = {}
	if isTimer(timer) then
		killTimer(timer)
	end
end