TuningPanel = newclass "TuningPanel"

-- Цвета и прозрачность
local BACKGROUND_COLOR = {29, 29, 29}
local TEXT_BACKGROUND_COLOR = {255, 255, 255}
-- Размеры и расположение
local PADDING_X = 12
local PADDING_Y = 8
local ICON_SIZE = 36
local ICON_SPACE = 30
local CIRCLE_SIZE = 24

function TuningPanel:init(items, draw3d)
	self.items = {}
	for i, item in ipairs(items) do
		table.insert(self.items, {icon = item.icon, text = item.text, key = item.key})
	end
	self.draw3d = not not draw3d
	self.screenSize = Vector2(guiGetScreenSize())

	self.activeItem = 1

	-- Подсчёт размеров
	local itemsCount = #self.items
	self.width = PADDING_X * 2 + ICON_SIZE * itemsCount + ICON_SPACE * (itemsCount - 1)
	self.height = PADDING_Y * 2 + ICON_SIZE
	self.x = self.screenSize.x / 2 - self.width / 2 - self.width * 0.2
	self.y = 40
	self.textBoxWidth = 0
	self.textBoxWidthTarget = 0
	--
	self.font = Assets.fonts.tuningPanelText
	self.keyFont = Assets.fonts.tuningPanelKey
	self.activeItemColor = Garage.themePrimaryColor
	self:updateTextBox() 
	self.textBackgroundAlpha = 30
	self.backgroundAlpha = 230
	self.highlightSelection = false	
end

function TuningPanel:getActiveItem()
	return self.activeItem
end

function TuningPanel:setActiveItem(item)
	self.activeItem = item
	self:updateTextBox()
end

function TuningPanel:updateTextBox()
	self.text = self.items[self.activeItem].text
	if type(self.text) == "string" then
		local textWidth = dxGetTextWidth(self.text, 1, self.font)
		self.textBoxWidthTarget = PADDING_X * 2 + textWidth
	else
		self.textBoxWidthTarget = 0
	end
	local width = self.width + self.textBoxWidth
end

function TuningPanel:selectNext()
	self.activeItem = self.activeItem + 1
	if self.activeItem > #self.items then
		self.activeItem = 1
	end
	self:updateTextBox()
end

function TuningPanel:getItem()

end

function TuningPanel:selectPrevious()
	self.activeItem = self.activeItem - 1 
	if self.activeItem < 1 then
		self.activeItem = #self.items
	end
	self:updateTextBox()
end

function TuningPanel:update(dt)
	if self.draw3d then
		local x, y = getScreenFromWorldPosition(GarageCar.getVehicle().position + Vector3(0, 0, 0.9))
		if x then
			self.x = x - self.width / 2 - self.width * 0.2
			self.y = y - self.height * 2
		end
	end

	self.textBoxWidth = self.textBoxWidth + (self.textBoxWidthTarget - self.textBoxWidth) * dt * 15
end

function TuningPanel:draw(fadeProgress)
	-- Основной фон
	dxDrawRectangle(
		self.x, 
		self.y, 
		self.width, 
		self.height, 
		tocolor(BACKGROUND_COLOR[1], BACKGROUND_COLOR[2], BACKGROUND_COLOR[3], self.backgroundAlpha * fadeProgress),
		false,
		true -- Sub pixel positioning
	)
	-- Отрисовка иконок
	local x, y = self.x + PADDING_X, self.y + PADDING_Y
	for i, item in ipairs(self.items) do
		local color = tocolor(255, 255, 255, 255 * fadeProgress)
		if i == self.activeItem then
			color = tocolor(self.activeItemColor[1], self.activeItemColor[2], self.activeItemColor[3], 255 * fadeProgress)
			if self.highlightSelection then
				dxDrawRectangle(x, y, ICON_SIZE, ICON_SIZE, tocolor(50, 50, 50, 255 * fadeProgress))
			end			
		end

		if item.key then
			local cx = x - PADDING_X - CIRCLE_SIZE / 2
			local cy = y - PADDING_Y - CIRCLE_SIZE / 2
			dxDrawImage(
				cx,
				cy,
				CIRCLE_SIZE,
				CIRCLE_SIZE,
				Assets.textures.buttonCircle,
				0, 0, 0,
				tocolor(BACKGROUND_COLOR[1], BACKGROUND_COLOR[2], BACKGROUND_COLOR[3], 255 * fadeProgress)
			)
			dxDrawText(
				item.key, 
				cx, 
				cy, 
				cx + CIRCLE_SIZE, 
				cy + CIRCLE_SIZE, 
				tocolor(255, 255, 255, 255 * fadeProgress),
				1, 
				self.keyFont,
				"center",
				"center",
				true,
				false,
				false,
				false,
				true
			)
		end
		dxDrawImage(x, y, ICON_SIZE, ICON_SIZE, item.icon, 0, 0, 0, color)
		x = x + ICON_SIZE + ICON_SPACE
	end

	if self.text then
		-- Фон прямоугольника с текстом
		dxDrawRectangle(
			self.x + self.width, 
			self.y, 
			self.textBoxWidth, 
			self.height, 
			tocolor(TEXT_BACKGROUND_COLOR[1], TEXT_BACKGROUND_COLOR[2], TEXT_BACKGROUND_COLOR[3], self.textBackgroundAlpha * fadeProgress),
			false,
			true -- Sub pixel positioning			
		)
		-- Отрисовка текста
		dxDrawText(
			self.text, 
			self.x + self.width, 
			self.y, 
			self.x + self.width + self.textBoxWidth, 
			self.y + self.height, 
			tocolor(255, 255, 255, 255 * fadeProgress),
			1, 
			self.font,
			"center",
			"center",
			true,
			false,
			false,
			false,
			true -- Sub pixel positioning	
		)
	end
end