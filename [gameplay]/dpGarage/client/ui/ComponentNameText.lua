ComponentNameText = newclass "ComponentNameText"
local screenSize = Vector2(guiGetScreenSize())

function ComponentNameText:init()
	self.x = screenSize.x / 2
	self.y = screenSize.y - 100
	self.width = 0
	self.height = 100
	
	self.text = ""

	-- Анимация текста
	self.animationProgress = 0
	self.animationTarget = 0
	self.animationSpeed = 2

	-- Минимальный масштаб текста
	self.scaleAnimationStart = 0.5
	-- Скорость масштабирования текста
	self.scaleAnimationSpeed = 2

	-- Цвет текста
	self.color = {255, 255, 255}
end

function ComponentNameText:changeText(text)
	if type(text) ~= "string" then
		return
	end
	self.animationTarget = 0
	self.animationProgress = 0
	self.text = text
end

function ComponentNameText:update(deltaTime)
	self.animationProgress = self.animationProgress + (self.animationTarget - self.animationProgress) * deltaTime * 2
	if self.animationTarget == 0 and self.animationProgress < 0.05 then
		self.animationTarget = 1
	end
end

function ComponentNameText:draw(fadeProgress)
	-- Анимация появления из прозрачности
	local alpha = math.max(0, self.animationProgress * 255 - 55) * fadeProgress
	local color = tocolor(self.color[1], self.color[2], self.color[3], alpha)
	-- Анимация увеличения
	local scale = math.min(1, 1 - self.scaleAnimationStart + self.scaleAnimationStart * self.animationProgress * self.scaleAnimationSpeed)

	dxDrawText(self.text, self.x, self.y, self.x + self.width, self.y + self.height, color, scale, Assets.fonts.componentName, "center", "center")
end