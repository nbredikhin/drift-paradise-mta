ComponentNameText = newclass "ComponentNameText"
local screenSize = Vector2(guiGetScreenSize())

function ComponentNameText:init()
	self.x = screenSize.x / 2
	self.y = screenSize.y - 130
	self.width = 0
	self.height = 100
	
	self.text = ""
	self.font = Assets.fonts.componentName
	self.infoFont = Assets.fonts.componentNameInfo
	self.fontHeight = dxGetFontHeight(1, self.font)
	-- Анимация текста
	self.animationProgress = 0
	self.animationTarget = 0
	self.animationSpeed = 2

	self.infoText = ""

	-- Минимальный масштаб текста
	self.scaleAnimationStart = 0.5
	-- Скорость масштабирования текста
	self.scaleAnimationSpeed = 2

	-- Цвет текста
	self.color = {255, 255, 255}
	self.infoColorHex = exports.dpUtils:RGBToHex(unpack(Garage.themePrimaryColor))
end

function ComponentNameText:changeText(text, price, level)
	if type(text) ~= "string" then
		return
	end
	self.animationTarget = 0
	self.animationProgress = 0
	self.text = text
	self:setInfo(price, level)
end

function ComponentNameText:setInfo(price, level)
	if (not price and not level) or (level <= 1 and price == 0) then
		self.infoText = ""
		return
	end
	if (not price or price == 0) and level then
		self.infoText = "Доступно с уровня " .. self.infoColorHex .. tostring(level)
		return
	end
	if (not level or level <= 1) and price then
		self.infoText = "Цена: " .. self.infoColorHex .. "$" .. tostring(price)
	end

	self.infoText = "Цена: " .. self.infoColorHex .. "$" .. tostring(price) .. "#FFFFFF Доступно с уровня " .. self.infoColorHex .. tostring(level)
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

	local y = self.y
	dxDrawText(self.text, self.x, y, self.x + self.width, y, color, scale, self.font, "center", "top")
	y = y + self.fontHeight
	dxDrawText(self.infoText, self.x, y, self.x + self.width, y, color, scale, self.infoFont, "center", "top", false, false, false, true)
end