-- Меню настройки конфигурации

ConfigurationMenu = newclass "ConfigurationMenu"
local screenSize = Vector2(guiGetScreenSize())

function ConfigurationMenu:init()
	self.width = 600
	self.height = 17
	self.x = (screenSize.x - self.width) / 2
	self.y = screenSize.y - self.height * 3 - 20

	self.value = 0
	self.currentValue = 0
end

function ConfigurationMenu:draw(fadeProgress)
	--dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(255, 0, 0))
	dxDrawImage(self.x, self.y, self.width, self.height, Assets.textures.slider, 0, 0, 0, tocolor(255, 255, 255, 255 * fadeProgress))
	self.currentValue = self.currentValue + (self.value - self.currentValue) * 0.1
	local x = (self.width - 16) * self.currentValue
	dxDrawImage(self.x - 8 + x, self.y - 8, 32, 32, Assets.textures.sliderCircle, 0, 0, 0, tocolor(255, 255, 255, 255 * fadeProgress))
end

function ConfigurationMenu:increase(deltaTime)
	self.value = self.value + 1 * deltaTime
	if self.value > 1 then
		self.value = 1
	end
end

function ConfigurationMenu:decrease(deltaTime)
	self.value = self.value - 1 * deltaTime
	if self.value < 0 then
		self.value = 0
	end
end