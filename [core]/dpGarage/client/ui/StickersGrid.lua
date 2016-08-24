StickersGrid = newclass "StickersGrid"

local BACKGROUND_COLOR = {42, 40, 41}

function StickersGrid:init()
	local screenSize = Vector2(exports.dpUI:getScreenSize())
	self.renderTarget = exports.dpUI:getRenderTarget()
	self.width = 1000
	self.height = 500
	self.x = screenSize.x / 2 - self.width / 2
	self.y = screenSize.y / 2 - self.height / 2 

	self.panel = TuningPanel({
		{icon = Assets.textures.stickersSection1, 	text = exports.dpLang:getString("garage_tuning_stickers_figures")},
		{icon = Assets.textures.stickersSection2, 	text = exports.dpLang:getString("garage_tuning_stickers_brands")},
		{icon = Assets.textures.stickersSection3, 	text = exports.dpLang:getString("garage_tuning_stickers_flags")},
		{icon = Assets.textures.stickersSection4, 	text = exports.dpLang:getString("garage_tuning_stickers_letters")},
		{icon = Assets.textures.stickersSection5, 	text = exports.dpLang:getString("garage_tuning_stickers_numbers")},	
		{icon = Assets.textures.stickersSection6, 	text = exports.dpLang:getString("garage_tuning_stickers_other")},	
	})
	self.y = self.y + self.panel.height / 2
	self.panel.x = self.x
	self.panel.y = self.y - self.panel.height
	self.panel.textBackgroundAlpha = 140
	self.panel.backgroundAlpha = 255

	self.stickersList = {}
	self.itemsHigh = 3
	self.itemSize = self.height / self.itemsHigh
	self.itemsWide = math.floor(self.width / self.itemSize)
	self.gridRenderTarget = dxCreateRenderTarget(self.width, self.height, true)
	self.gridScrollOffset = 0
	self.gridTargetScroll = 0
	self.gridScrollY = 0
	self.selectionX = 1
	self.selectionY = 1
	self.isGridActive = false
	self.panel.highlightSelection = not self.isGridActive
	self.stickerItemScale = 0.6

	self.itemTextHeight = 40
	self.font = Assets.fonts.stickersGridText

	self.scrollBarWidth = 6
	self.scrollBarHeight = 0
	self.scrollBarVisible = true

	self.activeSection = 1
	self:changeSection(1)
end

function StickersGrid:changeSection(sectionId)
	for i, item in ipairs(self.stickersList) do
		if isElement(item.texture) then
			--destroyElement(item.texture)
		end
	end
	self.stickersList = {}
	if not sectionId or type(TuningConfig.stickers[sectionId]) ~= "table" then
		return false
	end
	for i, sticker in ipairs(TuningConfig.stickers[sectionId]) do
		local item = {}
		for k, v in pairs(sticker) do
			item[k] = v
		end
		if not item.level then
			item.level = 1
		end
		if item.level < 1 then
			item.level = 1
		end
		if item.id then
			item.texture = Assets.textures["sticker_" .. tostring(item.id)]
			if item.texture then
				table.insert(self.stickersList, item)
			end
		end
	end
	local stickersHigh = math.floor((#self.stickersList - 1) / self.itemsWide) + 1
	if stickersHigh > self.itemsHigh then
		self.scrollBarHeight = self.itemsHigh / (stickersHigh - 2) * self.itemSize
		self.scrollBarVisible = true
	else
		self.scrollBarHeight = 0
		self.scrollBarVisible = false
	end
	return true
end

function StickersGrid:getStickerAt(x, y)
	local stickerIndex = (y - 1) * self.itemsWide + x
	return self.stickersList[stickerIndex]
end

function StickersGrid:getSelectedSticker()
	if not self.isGridActive then
		return false
	end
	return self:getStickerAt(self.selectionX, self.selectionY)
end

function StickersGrid:draw(fadeProgress)
	-- Отрисовка сетки
	dxSetRenderTarget(self.gridRenderTarget, true)
	local money = localPlayer:getData("money")
	local level = localPlayer:getData("level")
	for i, item in ipairs(self.stickersList) do
		math.randomseed(i)
		local backgroundColor = 0
		local itemX = ((i - 1) % self.itemsWide) + 1
		local itemY = math.floor((i - 1) / self.itemsWide) + 1
		if self.isGridActive and itemX == self.selectionX and itemY == self.selectionY then
			backgroundColor = tocolor(60, 60, 60, 255 * fadeProgress)
		end	
		local imageColor = {255, 255, 255, 255}
		local priceAlpha = 255
		if money < item.price or level < item.level then
			imageColor = {50, 50, 50, 255}
			priceAlpha = 150
		end	
		itemX = (itemX - 1) * self.itemSize
		itemY = (itemY - 1) * self.itemSize - self.gridScrollOffset

		dxDrawRectangle(itemX, itemY, self.itemSize, self.itemSize, backgroundColor)
		local scaleInverse = 1 - self.stickerItemScale
		dxDrawImage(
			itemX + self.itemSize * scaleInverse / 2, 
			itemY + self.itemSize * scaleInverse / 2, 
			self.itemSize * self.stickerItemScale, 
			self.itemSize * self.stickerItemScale, 
			item.texture,
			0, 0, 0,
			tocolor(imageColor[1], imageColor[2], imageColor[3], imageColor[4] * fadeProgress)
		)
		dxDrawText("$#FFFFFF" .. tostring(item.price), 
			itemX + 10, 
			itemY - self.itemTextHeight + self.itemSize, 
			itemX + self.itemSize / 2, 
			itemY + self.itemSize,
			tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3], priceAlpha * fadeProgress),
			1,
			self.font,
			"left",
			"center",
			false, false, false, true
		)
		dxDrawText("★" .. tostring(item.level), 
			itemX + self.itemSize / 2, 
			itemY - self.itemTextHeight + self.itemSize, 
			itemX + self.itemSize - 10, 
			itemY + self.itemSize,
			tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3], priceAlpha * fadeProgress),
			1,
			self.font,
			"right",
			"center"
		)		
	end
	dxSetRenderTarget()

	dxSetRenderTarget(self.renderTarget)
	self.panel:draw(fadeProgress)

	local x = self.x
	local y = self.y
	dxDrawRectangle(x, y, self.width, self.height, tocolor(BACKGROUND_COLOR[1], BACKGROUND_COLOR[2], BACKGROUND_COLOR[3], 255 * fadeProgress))
	dxDrawImage(x, y, self.width, self.height, self.gridRenderTarget)

	-- Полоса прокрутки
	if self.scrollBarVisible then
		x = x + self.width - self.scrollBarWidth
		dxDrawRectangle(x, y, self.scrollBarWidth, self.height, tocolor(255, 255, 255, 50 * fadeProgress))
		dxDrawRectangle(x, y + self.gridScrollOffset / self.itemSize * self.scrollBarHeight, self.scrollBarWidth, self.scrollBarHeight, tocolor(212, 0, 40, 255 * fadeProgress))
	end
	dxSetRenderTarget()
end

function StickersGrid:update(deltaTime)
	self.panel:update(deltaTime)

	self.gridScrollOffset = self.gridScrollOffset + (self.gridTargetScroll - self.gridScrollOffset) * 15 * deltaTime
end

function StickersGrid:destroy()
	if isElement(self.gridRenderTarget) then
		destroyElement(self.gridRenderTarget)
	end
	self:changeSection()
end

function StickersGrid:onKey(key)
	if self.isGridActive then
		if key == "arrow_l" then
			self.selectionX = self.selectionX - 1
			if self.selectionX < 1 then
				self.selectionX = self.itemsWide
				if not self:getSelectedSticker() then
					self.selectionX = 1
				end					
			end
			if not self:getSelectedSticker() then
				self.selectionX = self.selectionX + 1
			end					
		elseif key == "arrow_r" then
			self.selectionX = self.selectionX + 1
			if self.selectionX > self.itemsWide then
				self.selectionX = 1
			end
			if not self:getSelectedSticker() then
				self.selectionX = self.selectionX - 1
			end			
		elseif key == "arrow_u" then
			self.selectionY = self.selectionY - 1
			if self.selectionY < 1 then
				self.selectionY = 1
				self.isGridActive = false
				self.panel.highlightSelection = not self.isGridActive
			end
			-- Прокрутка вверх
			if self.selectionY - self.gridScrollY < 1 then
				self.gridScrollY = self.selectionY - 1
				self.gridTargetScroll = self.itemSize * self.gridScrollY
			end			
		elseif key == "arrow_d" then
			self.selectionY = self.selectionY + 1
			if not self:getSelectedSticker() then
				if self.selectionY - self.gridScrollY > self.itemsHigh and self:getStickerAt(1, self.selectionY) then
					self.selectionX = 1
				else
					self.selectionY = self.selectionY - 1
				end
			end
			-- Прокрутка вниз
			if self.selectionY - self.gridScrollY > self.itemsHigh then
				self.gridScrollY = self.selectionY - self.itemsHigh
				self.gridTargetScroll = self.itemSize * self.gridScrollY
			end
		end
	else
		if key == "arrow_l" then
			self.activeSection = self.activeSection - 1
			if self.activeSection < 1 then
				self.activeSection = 1
				return
			end
			self.panel:setActiveItem(self.activeSection)
			self:changeSection(self.activeSection)
		elseif key == "arrow_r" then
			self.activeSection = self.activeSection + 1
			if self.activeSection > #TuningConfig.stickers then
				self.activeSection = #TuningConfig.stickers
				return
			end
			self.panel:setActiveItem(self.activeSection)
			self:changeSection(self.activeSection)
		elseif key == "arrow_d" then
			if #self.stickersList > 0 then
				self.isGridActive = true
				self.panel.highlightSelection = not self.isGridActive
			end
			self.selectionX = 1
			self.selectionY = 1
		end
	end
end