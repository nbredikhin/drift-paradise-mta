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

local function hasSpoiler(id)
	if id == 0 then
		return true
	end
	if not GarageCar.hasDefaultSpoilers() and GarageCar.hasCustomSpoiler(id) then
		return true
	end
	local defaultSpoilersCount = #exports.dpShared:getTuningPrices("spoilers")
	if id <= defaultSpoilersCount and GarageCar.hasDefaultSpoilers() then
		return true
	elseif GarageCar.hasCustomSpoiler(id - defaultSpoilersCount) then
		return true
	end
	return false
end

function ComponentScreen:init(name)
	self.super:init()
	self.vehicle = GarageCar.getVehicle()
	-- Название компонента, который будет выбираться
	self.componentName = name

	local menuInfo = menuInfos[name]
	local items = {}
	local itemName = exports.dpLang:getString(menuInfo.item_locale)
	local vehicleComponents = getVehicleComponents(self.vehicle)
	for i = 1, TuningConfig.getComponentsCount(self.vehicle.model, self.componentName) + 1 do
		if name ~= "Spoilers" or (name == "Spoilers" and hasSpoiler(i - 1)) then
			local componentConfig = TuningConfig.getComponentConfig(self.vehicle.model, self.componentName, i - 1)
			if i == 1 or GarageCar.hasComponent(self.componentName, i - 1) then
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
		end
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
	GarageCar.resetTuning()
	local componentId = self.menu.activeItem - 1	
	if self.componentName == "WheelsF" or self.componentName == "WheelsR" then
		local letter = "F"
		if self.componentName == "WheelsR" then
			letter = "R"
		end
		if componentId == 0 then
			-- Сбросить развал и т д
			GarageCar.previewTuning("WheelsOffset" .. letter, 0)
			GarageCar.previewTuning("WheelsAngle" .. letter, 0)
			GarageCar.previewTuning("WheelsWidth" .. letter, 0)
		end
		-- Сбросить цвет
		GarageCar.previewTuning("WheelsColor" .. letter, {255, 255, 255})
	elseif self.componentName == "Spoilers" then
		if not GarageCar.hasDefaultSpoilers() and componentId > 0 then
			local defaultSpoilers = exports.dpShared:getTuningPrices("spoilers")
			GarageCar.previewTuning(self.componentName, componentId + #defaultSpoilers)
		else
			GarageCar.previewTuning(self.componentName, componentId)
		end
	else
		GarageCar.previewTuning(self.componentName, componentId)
	end
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
		local componentId = this.menu.activeItem - 1
		Garage.buy(item.price, item.level, function(success)
			if success then
				GarageCar.applyTuning(this.componentName, componentId)
				this.screenManager:showScreen(ComponentsScreen(this.componentName))

				if this.componentName == "WheelsF" or this.componentName == "WheelsR" then
					local letter = "F"
					if this.componentName == "WheelsR" then
						letter = "R"
					end
					if componentId == 0 then
						-- Сбросить развал и т д
						GarageCar.applyTuning("WheelsOffset" .. letter, 0)
						GarageCar.applyTuning("WheelsAngle" .. letter, 0)
						GarageCar.applyTuning("WheelsWidth" .. letter, 0)
					end
					-- Сбросить цвет
					GarageCar.applyTuning("WheelsColor" .. letter, {255, 255, 255})
				elseif this.componentName == "Spoilers" then
					if not GarageCar.hasDefaultSpoilers() then
						local defaultSpoilers = exports.dpShared:getTuningPrices("spoilers")
						if componentId > 0 then
							GarageCar.applyTuning(this.componentName, componentId + #defaultSpoilers)
						end
					else
						GarageCar.applyTuning(this.componentName, componentId)
					end
				end
			end
		end)
	end
end