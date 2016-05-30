StickersControlsMenu = newclass "StickersControlsMenu"
local screenSize = Vector2(guiGetScreenSize())

function StickersControlsMenu:init()
	self.items = {
		{button = "W", icon = Assets.textures.stickersMoveIcon},
		{button = "E", icon = Assets.textures.stickersScaleIcon},
		{button = "R", icon = Assets.textures.stickersRotateIcon},
		{button = "T", icon = Assets.textures.stickersColorIcon}
	}
	self.selectedItem = 1
	self.iconSize = 32
	self.textFieldSize = 32
	self.space = 3
	self.spaceBetweenItems = 10

	self.itemWidth = self.iconSize + self.space + self.textFieldSize
	self.itemHeight = self.iconSize
	self.width = (self.itemWidth + self.spaceBetweenItems) * (#self.items + 1) - self.spaceBetweenItems
	self.y = 20

	self.selectedColor = Garage.themePrimaryColor
	self.selectedScale = 1.5
end

function StickersControlsMenu:draw(fadeProgress)
	local x = screenSize.x / 2 - self.width / 2
	local y = self.y - self.y * (1 - fadeProgress)
	local alpha = 255 * fadeProgress
	for i, item in ipairs(self.items) do
		local color = tocolor(255, 255, 255, alpha)
		local scale = 1
		local text = "- " .. item.button
		if i == self.selectedItem then
			color = tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3], alpha)
			scale = self.selectedScale
			text = item.button
		end
		local scaleSizeOffset = (self.iconSize * scale - self.iconSize)
		dxDrawImage(
			x - scaleSizeOffset / 2,
			y - scaleSizeOffset / 2,
			self.iconSize + scaleSizeOffset,
			self.iconSize + scaleSizeOffset,
			item.icon,
			0, 0, 0,
			color
		)
		x = x + self.iconSize + self.space
		dxDrawText(text, x, y, x + self.textFieldSize, y + self.itemHeight, color, scale, Assets.fonts.controlIconButton, "center", "center")
		x = x + self.itemWidth + self.spaceBetweenItems
	end
end

function StickersControlsMenu:update(deltaTime)

end