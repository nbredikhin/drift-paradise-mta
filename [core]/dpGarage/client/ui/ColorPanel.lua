ColorPanel = newclass "ColorPanel"
local COLOR_CHANGE_SPEED = 1
local SLOW_SPEED_MUL = 0.14

function ColorPanel:init(headerText)
	self.x = 0 
	self.y = 0
	self.resolution = Vector2(330, 350)
	self.showPrice = true

	self.headerHeight = 70
	self.headerText = headerText

	self.labelHeight = 50
	self.labels = {
		hue = exports.dpLang:getString("garage_tuning_paint_hue"),
		saturation = exports.dpLang:getString("garage_tuning_paint_saturation"),
		brightness = exports.dpLang:getString("garage_tuning_paint_brightness"),
		buy = exports.dpLang:getString("garage_tuning_buy_button")
	}

	self.barHeight = 20
	self.barOffset = 20

	self.bars = {
		{text = self.labels.hue, 		value = 0, texture = Assets.textures.colorsHue},
		{text = self.labels.saturation, value = 1, texture = Assets.textures.colorsSaturation},
		{text = self.labels.brightness, value = 1, texture = Assets.textures.colorsBrightness},
	}
	self.activeBar = 1
	self.price = 0
end

function ColorPanel:getColor()
	local r, g, b = hsvToRgb(self.bars[1].value, self.bars[2].value, self.bars[3].value, 255)
	return r, g, b
end

function ColorPanel:setColor(r, g, b)
	local h, s, v = rgbToHsv(r, g, b, 255)
	self.bars[1].value = h
	self.bars[2].value = s
	self.bars[3].value = v
end

function ColorPanel:draw(fadeProgress)
	if not fadeProgress then fadeProgress = 1 end
	dxDrawRectangle(self.x, self.y, self.resolution.x, self.resolution.y, tocolor(42, 40, 41, 255 * fadeProgress))
	dxDrawRectangle(self.x, self.y, self.resolution.x, self.headerHeight, tocolor(32, 30, 31, 255 * fadeProgress))
	dxDrawText(self.headerText, self.x + 20, self.y, self.x + self.resolution.x, self.y + self.headerHeight, tocolor(255, 255, 255, 255 * fadeProgress), 1, Assets.fonts.colorMenuHeader, "left", "center")
	
	if self.showPrice then
		local priceText = ""
		if self.price > 0 then
			priceText = "$" .. tostring(self.price)
		else
			priceText = exports.dpLang:getString("price_free")
		end
		dxDrawText(priceText, self.x, self.y, self.x + self.resolution.x - 20, self.y + self.headerHeight, tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3], 255 * fadeProgress), 1, Assets.fonts.ColorPanelPrice, "right", "center")
	end

	local y = self.y + self.headerHeight
	local barWidth = self.resolution.x - self.barOffset * 2
	for i, bar in ipairs(self.bars) do
		local a = 255
		local cursorSize = 5
		if i == self.activeBar then
			cursorSize = 10
		else
			a = 200
		end

		local r, g, b = hsvToRgb(self.bars[1].value, 1, 1, 255)

		-- Подпись
		dxDrawText(bar.text, self.x, y, self.x + self.resolution.x, y + self.labelHeight, tocolor(255, 255, 255, a * fadeProgress), 1, Assets.fonts.menuLabel, "center", "center")
		y = y + self.labelHeight

		-- Полоса
		if i == self.activeBar then
			dxDrawRectangle(self.x + self.barOffset - 1, y - 1, barWidth + 2, self.barHeight + 2, tocolor(255, 255, 255, 255 * fadeProgress))
		end
		dxDrawRectangle(self.x + self.barOffset, y, barWidth, self.barHeight, tocolor(r, g, b, a * fadeProgress))
		dxDrawImage(self.x + self.barOffset, y, barWidth, self.barHeight, bar.texture, 0, 0, 0, tocolor(255, 255, 255, 255 * fadeProgress))
		
		-- Ползунок
		local x = (barWidth + 2) * bar.value
		x = self.barOffset + math.max(0, math.min(x, barWidth - cursorSize + 2)) - 1
		dxDrawRectangle(self.x + x, y - cursorSize, cursorSize, self.barHeight + cursorSize * 2, tocolor(255, 255, 255, 255 * fadeProgress))	

		y = y + self.barHeight * 2
	end
end

function ColorPanel:selectNextBar()
	self.activeBar = self.activeBar + 1
	if self.activeBar > #self.bars then
		self.activeBar = 1
	end
end

function ColorPanel:selectPreviousBar()
	self.activeBar = self.activeBar - 1
	if self.activeBar < 1 then
		self.activeBar = #self.bars
	end
end

function ColorPanel:increase(dt)
	local speedMul = COLOR_CHANGE_SPEED
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end	
	self.bars[self.activeBar].value = self.bars[self.activeBar].value + speedMul * dt
	if self.bars[self.activeBar].value > 1 then
		self.bars[self.activeBar].value = 1
	end
end

function ColorPanel:decrease(dt)
	local speedMul = COLOR_CHANGE_SPEED
	if getKeyState("lalt") then
		speedMul = SLOW_SPEED_MUL
	end	
	self.bars[self.activeBar].value = self.bars[self.activeBar].value - speedMul * dt
	if self.bars[self.activeBar].value < 0 then
		self.bars[self.activeBar].value = 0
	end
end