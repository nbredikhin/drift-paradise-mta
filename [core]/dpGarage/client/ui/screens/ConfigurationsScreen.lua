-- Экран переключения между конфигурациями компонентов
ConfigurationsScreen = Screen:subclass "ConfigurationsScreen"
local screenSize = Vector2(guiGetScreenSize())

function ConfigurationsScreen:init(componentName)
	self.super:init()

	local suspensionPrice, suspensionLevel = unpack(exports.dpShared:getTuningPrices("suspension"))
	local upgradesLevel = exports.dpShared:getTuningPrices("upgrades_level")
	self.componentsSelection = ComponentSelection({
		{name="Upgrades", 	camera="upgrades", 	 locale="garage_tuning_config_upgrades",   price = 0, level = upgradesLevel},
		{name="Suspension", camera="suspension", locale="garage_tuning_config_suspension", price = suspensionPrice, level = suspensionLevel}
	})

	local vehicle = GarageCar.getVehicle()

	-- Если на машине установлены передние или задние диски
	local hasWheels = false
	if vehicle:getData("WheelsR") and vehicle:getData("WheelsR") > 0 then
		self.componentsSelection:addComponent("RearWheels",  "wheelsOffsetRear", "garage_tuning_config_rear_wheels", nil, unpack(exports.dpShared:getTuningPrices("wheels_advanced")))
		hasWheels = true
	end
	if vehicle:getData("WheelsF") and vehicle:getData("WheelsF") > 0 then
		self.componentsSelection:addComponent("FrontWheels", "wheelsOffsetFront", "garage_tuning_config_front_wheels", nil, unpack(exports.dpShared:getTuningPrices("wheels_advanced")))
		hasWheels = true
	end	
	if hasWheels then
		self.componentsSelection:addComponent("WheelsSize", "wheelsSize", "garage_tuning_config_wheels_size", nil, unpack(exports.dpShared:getTuningPrices("wheels_size")))	
	end
	
	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end

	self.configurationScreens = {
		FrontWheels = WheelsScreen,
		RearWheels = WheelsScreen,
		Upgrades = UpgradesScreen
	}	
end

function ConfigurationsScreen:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function ConfigurationsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function ConfigurationsScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		-- Перейти к следующему компоненту
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		-- Перейти к предыдущему компоненту
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		self.componentsSelection:stop()
		-- Вернуться на предыдущий экран
		self.screenManager:showScreen(TuningScreen(4))
		GarageUI.showSaving()
		GarageCar.save()
	elseif key == "enter" then
		if not self.componentsSelection:canBuy() then
			return
		end		
		local componentName = self.componentsSelection:getSelectedComponentName()
		if not componentName then
			return
		end
		-- Отобразить экран настройки конфигурации
		self.componentsSelection:stop()
				
		local screenClass = ConfigurationScreen
		if self.configurationScreens[componentName] then
			screenClass = self.configurationScreens[componentName]
		end
		self.screenManager:showScreen(screenClass(componentName))
	end	
end