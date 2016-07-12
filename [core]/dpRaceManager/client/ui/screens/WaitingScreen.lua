-- Экран ожидания гонки
WaitingScreen = Screen:subclass("WaitingScreen")
local screenSize = Vector2(guiGetScreenSize())

function WaitingScreen:init()
	self.super:init()
end

function WaitingScreen:draw()
	self.super:draw()
	dxDrawText("Ожидание остальных игроков", 0, screenSize.y * 0.8, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255 * self.fadeProgress), 1, "default", "center", "center")
end