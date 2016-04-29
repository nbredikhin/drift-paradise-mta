Drawable = newclass "Drawable"

function Drawable:init()
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	self.centerX = 0
	self.centerY = 0
	self.isVisible = true
end

function Drawable:draw()

end

function Drawable:update(deltaTime)

end