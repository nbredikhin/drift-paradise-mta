ItemsMenu = TuningMenu:subclass "ItemsMenu"

function ItemsMenu:init(items, position, rotation)
	check("ItemsMenu:new", {
		{items, "table"},
		{position, "userdata"},
		{rotation, "number"},
	})	
	self.items = items
	self.selectedItem = 1
	self.super:init(position, rotation, Vector2(1.4, 0.48 + 0.3 * #self.items + 0.15))

	self.itemRenderTarget = dxCreateRenderTarget(self.resolution.x, 70, false)
	self.selectionProgress = 0
	self.selectionSpeed = 4
	self.selectionOffset = 0.3
	self.selectionColor = tocolor(212, 0, 40)

	self:redrawSelection()
end

function ItemsMenu:redrawSelection()
	dxSetRenderTarget(self.itemRenderTarget)
	dxDrawRectangle(0, 0, self.resolution.x, 70, self.selectionColor)
	dxDrawText(exports.dpLang:getString(self.items[self.selectedItem]), 0, 0, self.resolution.x, 70, tocolor(255, 255, 255), 1, Assets.fonts.menu, "center", "center")
	dxSetRenderTarget()
end

function ItemsMenu:onKey(key)
	local prev = self.selectedItem
	if key == "arrow_u" then
		self.selectedItem = self.selectedItem - 1
	elseif key == "arrow_d" then
		self.selectedItem = self.selectedItem + 1
	end
	self.selectedItem = math.min(#self.items, math.max(1, self.selectedItem))
	if self.selectedItem ~= prev then		
		self.selectionProgress = 0.3
	end
end	

function ItemsMenu:getItem()
	return self.items[self.selectedItem]
end

function ItemsMenu:drawSelectedItem(fadeProgress)
	local position = self.position + Vector3(0, 0, self.size.y / 2 - 0.50 - 0.28 * self.selectedItem)
	local rad = math.rad(self.rotation)
	local lookOffset = Vector3(math.cos(rad), math.sin(rad), 0)
	local animMul = math.sin(getTickCount() / 300)
	local anim = Vector3(0, 0, 0.01 * self.selectionProgress) * animMul
	dxDrawMaterialLine3D(
		position + Vector3(0, 0, 0.3) + lookOffset * self.selectionOffset * self.selectionProgress + anim, 
		position + lookOffset * self.selectionOffset * self.selectionProgress + anim,
		self.itemRenderTarget, 
		self.size.x + 0.05 * self.selectionProgress, 
		tocolor(255, 255, 255, (230 + 25 * math.sin(getTickCount() / 200)) * fadeProgress),
		position + lookOffset
	)	
end

function ItemsMenu:draw(fadeProgress)
	self.super:draw(fadeProgress)

	dxSetRenderTarget(self.renderTarget, true)
	local y = -130

	-- Логотип
	local logoSize = self.resolution.x
	dxDrawImage(0, y, logoSize, logoSize, Assets.textures.logo)
	y = y + logoSize / 2 + 10

	-- Стрелка вверх
	local arrowSize = self.resolution.x / 4
	local arrowsX = (self.resolution.x - arrowSize) / 2
	local arrowsOffset = math.sin(getTickCount() / 200) * 5
	dxDrawImage(arrowsX, y + arrowsOffset, arrowSize, arrowSize, Assets.textures.arrow, -90)

	-- Кнопки
	y = y + arrowSize - 15
	local itemWidth = self.resolution.x
	local itemHeight = 70
	for i, item in ipairs(self.items) do
		if i == self.selectedItem then
			self:drawSelectedItem(fadeProgress)
		else
			dxDrawRectangle(0, y, itemWidth, itemHeight, tocolor(42, 40, 41))
			dxDrawText(exports.dpLang:getString(item), 0, y, itemWidth, y + itemHeight, tocolor(255, 255, 255), 1, Assets.fonts.menu, "center", "center")
		end
		y = y + itemHeight
	end

	-- Стрелка вниз
	y = y - itemHeight + 55
	dxDrawImage(arrowsX, y - arrowsOffset, arrowSize, arrowSize, Assets.textures.arrow, 90)
	dxSetRenderTarget()
	self:redrawSelection()
end

function ItemsMenu:destroy()
	self.super:destroy()
	if isElement(self.itemRenderTarget) then
		destroyElement(self.itemRenderTarget)
	end
end

function ItemsMenu:update(deltaTime)
	self.super:update(deltaTime)

	self.selectionProgress = math.min(1, self.selectionProgress + self.selectionSpeed * deltaTime)
end