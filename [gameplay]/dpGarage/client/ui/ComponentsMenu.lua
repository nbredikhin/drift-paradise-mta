local ITEM_WIDTH = 1.2
local ITEM_HEIGHT = 0.24
local ITEM_SPACE = 0.1
local ITEM_BACKGROUND_COLOR = {42, 40, 41}
local SELECTED_OFFSET = 0.1
local SELECTED_SCALE = 1.2

local MenuItem = TuningMenu:subclass "MenuItem"

function MenuItem:init(position, rotation)
	self.super:init(position, rotation, Vector2(ITEM_WIDTH, ITEM_HEIGHT))
	self.initialPosition = self.position
	self.targetPosition = self.initialPosition
	self.targetSize = Vector2(self.size)
	self.selectedSize = self.targetSize * SELECTED_SCALE
	self.normalSize = Vector2(self.size)
	self.alpha = 255
	self.targetAlpha = 255
	self.offset = 0
	self.targetOffset = 0
	self.price = 0
	self.name = ""
end

function MenuItem:draw(fadeProgress)
	self.super:draw(fadeProgress)
	dxSetRenderTarget(self.renderTarget, true)
	local color = tocolor(ITEM_BACKGROUND_COLOR[1], ITEM_BACKGROUND_COLOR[2], ITEM_BACKGROUND_COLOR[3], self.alpha * fadeProgress)
	dxDrawRectangle(0, 0, self.resolution.x, self.resolution.y, color)
	dxDrawText(tostring(self.name), 0, 0, self.resolution.x * 0.6, self.resolution.y, tocolor(255, 255, 255, self.alpha), 1, Assets.fonts.componentItem, "center", "center")

	local priceText = ""
	if self.price > 0 then
		priceText = "$" .. tostring(self.price)
	else
		priceText = exports.dpLang:getString("price_free")
	end
	dxDrawText(priceText, self.resolution.x * 0.6, 0, self.resolution.x, self.resolution.y, tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3], self.alpha), 1, Assets.fonts.componentItemInfo, "center", "center")
	dxSetRenderTarget()
end

function MenuItem:update(dt)
	self.super:update(dt)
	self.size = self.size + (self.targetSize - self.size) * 10 * dt
	self.alpha = self.alpha + (self.targetAlpha - self.alpha) * 10 * dt
	self.offset = self.offset + (self.targetOffset - self.offset) * 10 * dt
	self.initialPosition = self.initialPosition + (self.targetPosition - self.initialPosition) * dt * 10
	local rad = math.rad(self.rotation)
	local offsetPosition = Vector3(math.cos(rad), math.sin(rad), 0) * self.offset
	self.position = self.initialPosition + offsetPosition
end

-- Меню выбора компонента

ComponentsMenu = newclass "ComponentsMenu"

function ComponentsMenu:init(position, rotation, items)
	self.position = position
	self.rotation = rotation
	self.size = size

	self.menuItems = {}
	for i = 1, 3 do
		self.menuItems[i] = MenuItem(self.position, rotation)
	end

	self.activeItem = 1
	self.items = items
	self:updateMenuItems()
end

function ComponentsMenu:draw(fadeProgress)
	for i, menuItem in ipairs(self.menuItems) do
		menuItem:draw(fadeProgress)
	end
end

function ComponentsMenu:update(dt)
	for i, menuItem in ipairs(self.menuItems) do
		menuItem:update(dt)
	end
end

function ComponentsMenu:destroy()
	for i, menuItem in ipairs(self.menuItems) do
		menuItem:destroy()
	end
end

function ComponentsMenu:updateMenuItems()
	local position = self.position + Vector3(0, 0, ITEM_HEIGHT * 1.5)
	for i = 1, 3 do
		self.menuItems[i].targetAlpha = 220
		self.menuItems[i].targetOffset = 0
		self.menuItems[i].targetPosition = Vector3(position.x, position.y, position.z)
		self.menuItems[i].targetSize = self.menuItems[i].normalSize 
		local itemIndex = self.activeItem + i - 2
		if itemIndex >= 1 and itemIndex <= #self.items then
			self.menuItems[i].name = self.items[itemIndex].name
			self.menuItems[i].price = self.items[itemIndex].price
		end
		position = position - Vector3(0, 0, ITEM_HEIGHT + ITEM_SPACE)
	end
	self.menuItems[2].targetSize = self.menuItems[2].selectedSize
	self.menuItems[2].targetAlpha = 255
	self.menuItems[2].targetOffset = SELECTED_OFFSET

	if self.activeItem == 1 then
		self.menuItems[1].targetAlpha = 0
	end
	if self.activeItem == #self.items then
		self.menuItems[3].targetAlpha = 0
	end	
end

function ComponentsMenu:showNext()
	self.activeItem = self.activeItem + 1
	if self.activeItem > #self.items then
		self.activeItem = #self.items
		return
	end

	self.menuItems[1], self.menuItems[2], self.menuItems[3] = self.menuItems[2], self.menuItems[3], self.menuItems[1]

	self:updateMenuItems()
end

function ComponentsMenu:showPrevious()
	self.activeItem = self.activeItem - 1
	if self.activeItem < 1 then
		self.activeItem = 1
		return
	end
	self.menuItems[1], self.menuItems[2], self.menuItems[3] = self.menuItems[3], self.menuItems[1], self.menuItems[2]

	self:updateMenuItems()
end

function ComponentsMenu:setActiveItem(item)
	if type(item) ~= "number" then
		return false
	end
	self.activeItem = math.max(1, math.min(item, #self.items))

	self:updateMenuItems()
end