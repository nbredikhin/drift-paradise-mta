StickerPreview = newclass "StickerPreview"

function StickerPreview:init()
	local screenSize = Vector2(exports.dpUI:getScreenSize())
	self.renderTarget = exports.dpUI:getRenderTarget()
	self.width = 160
	self.height = 160
	self.headerHeight = 35
	self.labelHeight = 30
	self.x = screenSize.x  - self.width - 20
	self.y = screenSize.y / 2 - self.height / 2

	self.texture = false
	self.stickerColor = tocolor(255, 255, 255)
	self.stickerScale = 0.7
end

function StickerPreview:draw(fadeProgress)
	dxSetRenderTarget(self.renderTarget)
	dxDrawRectangle(self.x, self.y - self.headerHeight, self.width, self.headerHeight, tocolor(32, 30, 31, 255 * fadeProgress))
	dxDrawText(
		string.format(exports.dpLang:getString("garage_tuning_sticker_next"), "L"), 
		self.x, 
		self.y - self.headerHeight, 
		self.x + self.width, 
		self.y,
		tocolor(255, 255, 255, 255 * fadeProgress),
		1,
		Assets.fonts.stickerPreviewHelp,
		"center", "center"		
	)
	dxDrawRectangle(self.x, self.y, self.width, self.height, tocolor(42, 40, 41, 255 * fadeProgress))
	dxDrawRectangle(self.x, self.y + self.height, self.width, self.headerHeight, tocolor(32, 30, 31, 255 * fadeProgress))
	dxDrawText(
		string.format(exports.dpLang:getString("garage_tuning_sticker_prev"), "K"),
		self.x, 
		self.y + self.height, 
		self.x + self.width, 
		self.y + self.height + self.headerHeight,
		tocolor(255, 255, 255, 255 * fadeProgress),
		1,
		Assets.fonts.stickerPreviewHelp,
		"center", "center"
	)

	local y = self.y + self.height + self.headerHeight
	local c = 100
	local isMirroringEnabled = CarTexture.isMirroringEnabled()
	if isMirroringEnabled then
		c = 255
	end
	dxDrawText(
		string.format(exports.dpLang:getString("garage_tuning_sticker_mirror"), "1"),
		self.x, 
		y, 
		self.x + self.width, 
		y + self.labelHeight,
		tocolor(c, c, c, 255 * fadeProgress),
		1,
		Assets.fonts.stickerPreviewHelp,
		"left", "center"
	)
	y = y + self.labelHeight

	c = 100
	if isMirroringEnabled and CarTexture.isTextMirroringEnabled() then
		c = 255
	end	
	dxDrawText(
		string.format(exports.dpLang:getString("garage_tuning_sticker_mirror_text"), "2"),
		self.x, 
		y, 
		self.x + self.width, 
		y + self.labelHeight,
		tocolor(c, c, c, 255 * fadeProgress),
		1,
		Assets.fonts.stickerPreviewHelp,
		"left", "center"
	)

	local x = self.x + self.width * (1 - self.stickerScale) / 2
	local y = self.y + self.height * (1 - self.stickerScale) / 2
	if self.texture then
		dxDrawImage(x, y, self.width * self.stickerScale, self.height * self.stickerScale, self.texture, 0, 0, 0, self.stickerColor)
	end
	dxSetRenderTarget()
end

function StickerPreview:setStickerColor(color)
	if color then
		self.stickerColor = color
	end
end

function StickerPreview:showSticker(stickerId)
	if stickerId then
		self.texture = Assets.textures["sticker_" .. tostring(stickerId)]
	end
end

function StickerPreview:hideSticker()
	self.texture = false
end