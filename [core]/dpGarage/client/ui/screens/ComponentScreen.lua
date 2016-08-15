-- Экран покупки компонента

ComponentScreen = Screen:subclass "ComponentScreen"

-- Расположение 3D меню для разных компонентов
local menuInfos = {}
menuInfos["FrontBump"] 	= {position = Vector3(2917, -3188.3, 2535.6), 	angle = 30, item_locale="garage_tuning_item_bumper"}
menuInfos["Spoilers"] 	= {position = Vector3(2915, -3188.3, 2535.8), 	angle = 185,item_locale="garage_tuning_item_spoiler"}
menuInfos["RearBump"] 	= {position = Vector3(2915, -3184.2, 2535.6), 	angle = 190,item_locale="garage_tuning_item_bumper"}
menuInfos["WheelsF"] 	= {position = Vector3(2913.8, -3184.3, 2535.3), angle = 15, item_locale="garage_tuning_item_wheel"}
menuInfos["WheelsR"] 	= {position = Vector3(2912.3, -3184.3, 2535.3), angle = 15, item_locale="garage_tuning_item_wheel"}
menuInfos["SideSkirts"] = {position = Vector3(2914.3, -3188.6, 2535.3), angle = 10, item_locale="garage_tuning_item_skirt"}
menuInfos["RearFends"] 	= {position = Vector3(2916.5, -3188.3, 2535.3), angle = 210,item_locale="garage_tuning_item_fender"}
menuInfos["FrontFends"] = {position = Vector3(2915, -3188.3, 2535.3), 	angle = 0, 	item_locale="garage_tuning_item_fender"}
menuInfos["Bonnets"] 	= {position = Vector3(2917, -3188.4, 2535.6), 	angle = 20,	item_locale="garage_tuning_item_bonnet"}
menuInfos["Exhaust"] 	= {position = Vector3(2915, -3184.2, 2535.4), 	angle = 190,item_locale="garage_tuning_item_exhaust"}
menuInfos["RearLights"] = {position = Vector3(2915, -3184.2, 2535.6), 	angle = 190,item_locale="garage_tuning_item_lights"}
menuInfos["FrontLights"] = {position = Vector3(2917, -3188.3, 2535.6), 	angle = 20,	item_locale="garage_tuning_item_lights"}

function ComponentScreen:init(name)
	self.super:init()
	self.vehicle = GarageCar.getVehicle()
	-- Название компонента, который будет выбираться
	self.componentName = name

	local menuInfo = menuInfos[name]
	local items = {}
	local itemName = exports.dpLang:getString(menuInfo.item_locale)
	for i = 1, TuningConfig.getComponentsCount(self.vehicle.model, self.componentName) + 1 do
		local componentConfig = TuningConfig.getComponentConfig(self.vehicle.model, self.componentName, i - 1)
		-- Обновить цену
		local price = componentConfig.price
		if type(price) ~= "number" then
			price = 0
		end
		local level = componentConfig.level
		if type(level) ~= "number" then
			level = 1
		end
		local name = itemName .. " " .. tostring(i - 1)
		if i == 1 then
			name = exports.dpLang:getString("garage_tuning_stock_text")
		end
		table.insert(items, {name = name, price = price, level = level})
	end
	-- 3D меню
	self.menu = ComponentsMenu(
		menuInfo.position, 
		menuInfo.angle,
		items
	)
	local data = self.vehicle:getData(name)
	if data then
		self.menu:setActiveItem(data + 1)
	end
	CameraManager.setState("preview" .. name, false, 3)

	--self:onItemChanged()
end

function ComponentScreen:show()
	self.super:show()
	if self.componentName == "FrontLights" or self.componentName == "RearLights" then
		GarageCar.getVehicle():setData("LightsState", true, false)
	end
end

function ComponentScreen:hide()
	self.super:hide()
	self.menu:destroy()
	GarageCar.getVehicle():setData("LightsState", false, false)
end

function ComponentScreen:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
end

function ComponentScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.menu:update(deltaTime)
end

function ComponentScreen:onItemChanged()
	GarageCar.previewTuning(self.componentName, self.menu.activeItem - 1)
end

function ComponentScreen:onKey(key)
	self.super:onKey(key)
	if key == "backspace" then
		GarageCar.resetTuning()
		self.screenManager:showScreen(ComponentsScreen(self.componentName))
	elseif key == "arrow_u" then
		self.menu:showPrevious()
		self:onItemChanged()
	elseif key == "arrow_d" then
		self.menu:showNext()
		self:onItemChanged()
	elseif key == "enter" then
		local item = self.menu.items[self.menu.activeItem]
		local this = self
		Garage.buy(item.price, item.level, function(success)
			if success then
				GarageCar.applyTuning(this.componentName, this.menu.activeItem  - 1)
				this.screenManager:showScreen(ComponentsScreen(this.componentName))
			end
		end)
	end
end