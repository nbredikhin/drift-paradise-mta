ScreenManager = {}
local currentScreen

function ScreenManager.show(screen)
	if not screen then
		currentScreen = nil
		return
	end
	if currentScreen then
		currentScreen.stop()
	end
	currentScreen = screen
	currentScreen.start()
end

function ScreenManager.draw()
	if currentScreen then
		currentScreen.draw()
	end
end

function ScreenManager.update(deltaTime)
	if currentScreen and currentScreen.update then
		currentScreen.update(deltaTime)
	end
end

function ScreenManager.hide()
	if not currentScreen then
		return false
	end
	currentScreen.stop()
	currentScreen = nil
end