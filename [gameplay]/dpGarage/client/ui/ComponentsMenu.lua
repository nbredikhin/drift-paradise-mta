-- Экран выбора компонента

ComponentsMenu = TuningMenu:subclass "ComponentsMenu"

local locales = {}
locales["FrontBump"] = {title = "garage_tuning_component_front_bump", 	item = "garage_tuning_item_bumper"}
locales["RearBump"] = {title = "garage_tuning_component_rear_bump",  	item = "garage_tuning_item_bumper"}
locales["Spoilers"] = {title = "garage_tuning_component_spoilers",		item = "garage_tuning_item_spoiler"}
locales["Wheels"] = {title = "garage_tuning_component_wheels",			item = "garage_tuning_item_wheel"}
locales["SideSkirts"] = {title = "garage_tuning_component_side_skirts",	item = "garage_tuning_item_skirt"}

function ComponentsMenu:init(position, rotation, name)
	self.super:init(position, rotation, Vector3(1.2, 1.4))

	local locale = locales[name]
	if not locale then
		locale = {}
	end
	self.itemName = exports.dpLang:getString(locale.item)
	self.headerText = exports.dpLang:getString(locale.title)
	self.buyText = exports.dpLang:getString("garage_tuning_buy_button")
	self.price = 10000
end

function ComponentsMenu:draw(fadeProgress)
	self.super:draw(fadeProgress)

	dxSetRenderTarget(self.renderTarget, true)
	dxDrawRectangle(0, 0, self.resolution.x, self.resolution.y, tocolor(42, 40, 41))
	dxDrawRectangle(0, 0, self.resolution.x, 70, tocolor(32, 30, 31))
	dxDrawText(self.headerText, 0, 0, self.resolution.x, 70, tocolor(255, 255, 255), 1, Assets.fonts.menu, "center", "center")
	dxDrawRectangle(0, self.resolution.y - 70, self.resolution.x, 70, tocolor(212, 0, 40))
	dxDrawText(self.buyText .. " $" .. self.price, 0, self.resolution.y - 70, self.resolution.x, self.resolution.y, tocolor(255, 255, 255), 1, Assets.fonts.menu, "center", "center")
	
	local y = 70
	local itemHeight = (self.resolution.y - 70 * 2) / 3 
	for i = 1, 3 do
		local color = tocolor(255, 255, 255, 150)
		local scale = 0.8
		if i == 2 then
			dxDrawRectangle(0, y, self.resolution.x, itemHeight, tocolor(255, 255, 255, 50))
			color = tocolor(255, 255, 255)
			scale = 1
		end
		dxDrawText(self.itemName .. " " .. i, 0, y, self.resolution.x, y + itemHeight, color, scale, Assets.fonts.menu, "center", "center")
		y = y + itemHeight
	end
	dxSetRenderTarget()
end

function ComponentsMenu:update(deltaTime)
	self.super:update(deltaTime)
end