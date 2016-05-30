StickerSelectionScreen = Screen:subclass "StickerSelectionScreen"

function StickerSelectionScreen:init(sideName)
	self.super:init()

	local screenSize = Vector2(exports.dpUI:getScreenSize())
	self.renderTarget = exports.dpUI:getRenderTarget()
	self.borderOffset = 70
	self.width = screenSize.x - self.borderOffset * 2
	self.height = screenSize.y - self.borderOffset * 2
	self.x = self.borderOffset
	self.y = self.borderOffset

	self.backgroundColor = {42, 40, 41}
	self.alpha = 255

	self.sideName = sideName

	self.headerHeight = 50
	self.headerColor = {29, 29, 29}

	self.sectionsList = {"Фигуры", "Аниме", "Стикеры", "Буквы", "Лого"}
	self.sectionWidth = self.width / #self.sectionsList
	self.activeSection = 1
	self.activeSectionColor = Garage.themePrimaryColor

	self.stickersGrid = {}
	self.stickersColumns = 8
	self.gridBorder = 10
	self.stickerItemSize = (self.width - self.gridBorder * 2) / self.stickersColumns
	self.stickersRows = math.floor((self.height - self.headerHeight) / self.stickerItemSize)
	for i = 1, self.stickersColumns do
		self.stickersGrid[i] = {}
	end
	self.activePanel = "sections"
	self.gridY = (self.height - self.headerHeight) / 2 - self.stickerItemSize * self.stickersRows / 2 + self.headerHeight
	self.gridRowOffset = 0
	self.activeSticker = Vector2(1, 1)
	self.activeStickerColor = Garage.themePrimaryColor
	self.stickerItemBorder = self.stickerItemSize * 0.15

	self:showStickersSection()
end

function StickerSelectionScreen:showStickersSection()
	for i = 1, self.stickersColumns do
		self.stickersGrid[i] = {}
	end	

	local x = 1
	local y = 1
	local stickersCount = 60
	for i = 1, stickersCount do
		local sticker = exports.dpAssets:createTexture("stickers/"..tostring(i)..".png")
		if isElement(sticker) then
			self.stickersGrid[x][y] = sticker
			x = x + 1 
			if x > self.stickersColumns then
				x = 1
				y = y + 1
			end
		end
	end

	self.totalRowsCount = math.floor(stickersCount / self.stickersColumns)
end

function StickerSelectionScreen:show()
	self.super:show()
	GarageUI.setHelpText("Стрелки - выбор, ENTER - купить, BACKSPACE - отмена")
end

function StickerSelectionScreen:hide()
	self.super:hide()
	GarageUI.resetHelpText()
end

function StickerSelectionScreen:draw()
	self.super:draw()
	local alpha = self.alpha * self.fadeProgress
	dxSetRenderTarget(self.renderTarget)

	dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(self.backgroundColor[1], self.backgroundColor[2], self.backgroundColor[3], alpha))
	dxDrawRectangle(self.x, self.y, self.width, self.headerHeight, tocolor(self.headerColor[1], self.headerColor[2], self.headerColor[3], alpha))
	local x = self.x
	local y = self.y
	-- Разделы
	for i, section in ipairs(self.sectionsList) do
		local textAlpha = 200 * self.fadeProgress
		if i == self.activeSection then
			local color = tocolor(255, 255, 255, 150 * self.fadeProgress)
			if self.activePanel == "sections" then
				color = tocolor(self.activeSectionColor[1], self.activeSectionColor[2], self.activeSectionColor[3], alpha)
			end
			dxDrawRectangle(x, y, self.sectionWidth, self.headerHeight, color)
			textAlpha = 255 * self.fadeProgress
		end
		dxDrawText(section, x, y, x + self.sectionWidth, y + self.headerHeight, tocolor(255, 255, 255, textAlpha), 1, Assets.fonts.stickersSelectionSection, "center", "center")
		x = x + self.sectionWidth
	end

	-- Таблица наклеек
	for i, row in ipairs(self.stickersGrid) do
		for j = 1 + self.gridRowOffset, self.stickersRows + self.gridRowOffset do
			local sticker = self.stickersGrid[i][j]
			if sticker then
				local x = self.x + self.gridBorder + (i - 1) * self.stickerItemSize
				local y = self.y + self.gridY + (j - 1 - self.gridRowOffset) * self.stickerItemSize
				local brightness = 150 * self.fadeProgress
				if i == self.activeSticker.x and j == self.activeSticker.y and self.activePanel == "stickers" then
					dxDrawRectangle(x, y, self.stickerItemSize, self.stickerItemSize, tocolor(self.activeStickerColor[1], self.activeStickerColor[2], self.activeStickerColor[3], alpha))
					brightness = 255 * self.fadeProgress
				end
				dxDrawImage(
					x + self.stickerItemBorder, 
					y + self.stickerItemBorder, 
					self.stickerItemSize - self.stickerItemBorder * 2, 
					self.stickerItemSize - self.stickerItemBorder * 2, 
					sticker,
					0, 0, 0,
					tocolor(brightness, brightness, brightness, alpha)
				)
			end
		end
	end
	
	dxSetRenderTarget()
end

function StickerSelectionScreen:update(deltaTime)
	self.super:update(deltaTime)
end

function StickerSelectionScreen:onKey(key)
	self.super:onKey(key)

	if key == "enter" then
		self.screenManager:showScreen(StickerEditorScreen(self.sideName))
	elseif key == "arrow_r" then
		if self.activePanel == "sections" then
			self.activeSticker.x = 1
			self.activeSticker.y = 1
			self.activeSection = self.activeSection + 1
			if self.activeSection > #self.sectionsList then
				self.activeSection = 1
			end
		else
			self.activeSticker.x = self.activeSticker.x + 1
			if self.activeSticker.x > self.stickersColumns or not self.stickersGrid[self.activeSticker.x][self.activeSticker.y] then
				self.activeSticker.x = 1
			end
		end
	elseif key == "arrow_l" then
		if self.activePanel == "sections" then
			self.activeSticker.x = 1
			self.activeSticker.y = 1			
			self.activeSection = self.activeSection - 1
			if self.activeSection < 1 then
				self.activeSection = #self.sectionsList
			end
		else
			self.activeSticker.x = self.activeSticker.x - 1
			if self.activeSticker.x < 1 or not self.stickersGrid[self.activeSticker.x][self.activeSticker.y] then
				self.activeSticker.x = self.stickersColumns
			end
		end
	elseif key == "arrow_u" then
		if self.activePanel == "sections" then
			self.activePanel = "stickers"
		else
			self.activeSticker.y = self.activeSticker.y - 1
			if self.activeSticker.y < 1 then
				self.activeSticker.y = 1
				self.activePanel = "sections"
			end
			self.gridRowOffset = math.max(0, self.activeSticker.y - self.stickersRows)
		end
	elseif key == "arrow_d" then
		if self.activePanel == "sections" then
			self.activePanel = "stickers"
		else
			self.activeSticker.y = self.activeSticker.y + 1
			if not self.stickersGrid[self.activeSticker.x][self.activeSticker.y] then
				self.activeSticker.y = 1
				self.gridRowOffset = 0
			end
			if self.activeSticker.y > self.stickersRows then
				self.gridRowOffset = self.activeSticker.y - self.stickersRows
			end
		end
	elseif key == "backspace" then
		self.screenManager:showScreen(StickerEditorScreen(self.sideName))
	end
end