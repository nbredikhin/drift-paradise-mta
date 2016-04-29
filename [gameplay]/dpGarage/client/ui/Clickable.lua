Clickable = Drawable:subclass "Clickable"
local screenWidth, screenHeight = guiGetScreenSize()

function Clickable:init()
	self.super:init()
	self.mouseHover = false
end

function Clickable:update()
	local mx, my = getCursorPosition()
	if not mx then
		return
	end
	mx, my = mx * screenWidth, my * screenHeight
	self.mouseHover = (
		mx >= self.x - self.width * self.centerX and 
		mx <= self.x + self.width - self.width * self.centerX and
		my >= self.y - self.height * self.centerY and 
		my <= self.y + self.height - self.height * self.centerY
	)
end