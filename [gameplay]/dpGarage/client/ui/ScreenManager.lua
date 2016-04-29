ScreenManager = {}
local currentScreen

function ScreenManager.show(screen)
	if not screen then
		error("Gtfo", 2)
	end
	ScreenManager.hide()
	screen:onShow()
	currentScreen = screen
end

function ScreenManager.draw()
	if currentScreen then
		currentScreen:draw()
	end
end

function ScreenManager.update(deltaTime)
	if currentScreen then
		currentScreen:update(deltaTime)
	end
end

function ScreenManager.hide()
	if not currentScreen then
		return false
	end
	currentScreen:onHide()
	currentScreen = nil
end