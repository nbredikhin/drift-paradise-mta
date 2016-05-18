-- Экран выбора компонента

ComponentsMenu = TuningMenu:subclass "ComponentsMenu"

local locales = {}
locales["FrontBump"] = {title = "garage_tuning_component_front_bump", 	item = "garage_tuning_item_bumper"}
locales["RearBump"] = {title = "garage_tuning_component_rear_bump",  	item = "garage_tuning_item_bumper"}
locales["Spoilers"] = {title = "garage_tuning_component_spoilers",		item = "garage_tuning_item_spoiler"}
locales["Wheels"] = {title = "garage_tuning_component_wheels",			item = "garage_tuning_item_wheel"}
locales["SideSkirts"] = {title = "garage_tuning_component_side_skirts",	item = "garage_tuning_item_skirt"}

function ComponentsMenu:init(position, rotation, name, count)
	self.super:init(position, rotation, Vector3(1.2, 1.4))

	local locale = locales[name]
	if not locale then
		locale = {}
	end
	self.itemName = exports.dpLang:getString(locale.item)
	self.headerText = exports.dpLang:getString(locale.title)
	self.buyText = exports.dpLang:getString("garage_tuning_buy_button")
	self.price = 99999
	self.currentComponent = 1
	self.componentsCount = count + 1
	if type(count) ~= "number" then
		self.componentsCount = 0
	end
	self.headerHeight = 65
end

function ComponentsMenu:setPrice(price)
	if type(price) == "number" then
		self.price = price
	else
		self.price = 0
	end
	return true
end

function ComponentsMenu:getComponent()
	return self.currentComponent - 1
end

function ComponentsMenu:draw(fadeProgress)
	self.super:draw(fadeProgress)

	dxSetRenderTarget(self.renderTarget, true)
	dxDrawRectangle(0, 0, self.resolution.x, self.resolution.y, tocolor(42, 40, 41))
	dxDrawRectangle(0, 0, self.resolution.x, self.headerHeight, tocolor(32, 30, 31))
	dxDrawText(self.headerText, 0, 0, self.resolution.x, self.headerHeight, tocolor(255, 255, 255), 1, Assets.fonts.menu, "center", "center")
	dxDrawRectangle(0, self.resolution.y - self.headerHeight, self.resolution.x, self.headerHeight, tocolor(212, 0, 40))
	local buyText = self.buyText .. " $" .. self.price
	if self.price == 0 then
		buyText = exports.dpLang:getString("garage_tuning_install_button")
	end
	dxDrawText(buyText, 0, self.resolution.y - self.headerHeight, self.resolution.x, self.resolution.y, tocolor(255, 255, 255), 1, Assets.fonts.menu, "center", "center")
	
	local y = 80
	-- Стрелка вверх
	local arrowSize = self.resolution.x / 8
	local arrowsX = (self.resolution.x - arrowSize) / 2
	local arrowsOffset = math.sin(getTickCount() / 200) * 2.5

	if self.currentComponent > 1 then
		dxDrawImage(arrowsX, y + arrowsOffset - 20, arrowSize, arrowSize, Assets.textures.arrow, -90)
	end

	local itemHeight = (self.resolution.y - 80 * 2) / 3 
	for i = 1, 3 do
		local index = self.currentComponent + i - 2
		if index > 0 and index <= self.componentsCount then
			local color = tocolor(255, 255, 255, 150)
			local scale = 0.8
			if i == 2 then
				dxDrawRectangle(0, y, self.resolution.x, itemHeight, tocolor(255, 255, 255, 50))
				color = tocolor(255, 255, 255)
				scale = 1
			end
			local text = self.itemName .. " " .. (index - 1)
			if index == 1 then
				text = exports.dpLang:getString("garage_tuning_stock_text")
			end
			dxDrawText(text, 0, y, self.resolution.x, y + itemHeight, color, scale, Assets.fonts.menu, "center", "center")
		end
		y = y + itemHeight
	end
	-- Стрелка вниз
	if self.currentComponent < self.componentsCount then
		dxDrawImage(arrowsX, y - arrowsOffset - 20, arrowSize, arrowSize, Assets.textures.arrow, 90)
	end
	dxSetRenderTarget()
end

function ComponentsMenu:showNext()
	self.currentComponent = self.currentComponent + 1
	if self.currentComponent > self.componentsCount then
		self.currentComponent = self.componentsCount
	end
end

function ComponentsMenu:showPrevious()
	self.currentComponent = self.currentComponent - 1
	if self.currentComponent < 1 then
		self.currentComponent = 1
	end
end

function ComponentsMenu:update(deltaTime)
	self.super:update(deltaTime)
end