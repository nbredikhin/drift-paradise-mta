RaceUI = {}
local isActive = false
local currentState
local screenManager

local stateScreens

local function draw()
	screenManager:draw()
end

local function update(deltaTime)
	deltaTime = deltaTime / 1000
	screenManager:update(deltaTime)
end

function RaceUI.start()
	if isActive then
		return false
	end
	isActive = true
	stateScreens = {
		waiting = WaitingScreen,
		no_map = WaitingScreen,
		running = RaceScreen
	}

	screenManager = ScreenManager()

	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)
end

function RaceUI.stop()
	if not isActive then
		return false
	end
	isActive = false

	screenManager:destroy()
	screenManager = nil

	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientPreRender", root, update)
end

function RaceUI.setState(state)
	if not isActive then
		return false
	end
	if type(state) ~= "string" then
		currentState = nil
		screenManager:hideScreen()
		return true
	end
	if not stateScreens[state] then
		RaceUI.setState(false)
		return false
	end
	if currentState then
		if currentState == state then
			return false
		end
		if stateScreens[currentState] == stateScreens[state] then
			return false
		end
	end
	local screenClass = stateScreens[state]
	currentState = state
	return screenManager:showScreen(screenClass:new())
end