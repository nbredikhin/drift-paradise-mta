-- Экран гонки
RaceScreen = Screen:subclass("RaceScreen")
local screenSize = Vector2(guiGetScreenSize())

function RaceScreen:init()
	self.super:init()
end

function RaceScreen:draw()
	self.super:draw()
	dxDrawText("TODO: Время, позиция и прочее", 0, screenSize.y * 0.8, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255 * self.fadeProgress), 1, "default", "center", "center")
end