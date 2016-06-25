-- Экран переключения между конфигурациями компонентов
ConfigurationsScreen = Screen:subclass "ConfigurationsScreen"
local screenSize = Vector2(guiGetScreenSize())

function ConfigurationsScreen:init(componentName)
	self.super:init()
	-- local items = {
	-- 	--{name="Suspension", 	camera="suspension", 		locale="garage_tuning_config_suspension"},
	-- 	{name="WheelsSize", 	camera="wheelsSize", 		locale="garage_tuning_config_wheels_size"},
	-- 	{name="FrontWheels", 	camera="wheelsOffsetFront", locale="garage_tuning_config_front_wheels"},
	-- 	{name="RearWheels", 	camera="wheelsOffsetRear", 	locale="garage_tuning_config_rear_wheels"},
		
	-- }

	self.componentsSelection = ComponentSelection({})

	local vehicle = GarageCar.getVehicle()
	-- Если на машине установлены передние или задние диски диски
	if (vehicle:getData("WheelsF") and vehicle:getData("WheelsF") > 0) or 
		(vehicle:getData("WheelsR") and vehicle:getData("WheelsR") > 0) 
	then
		self.componentsSelection:addComponent("WheelsSize",  "wheelsSize", 			"garage_tuning_config_wheels_size")
		self.componentsSelection:addComponent("FrontWheels", "wheelsOffsetFront", 	"garage_tuning_config_front_wheels")
		self.componentsSelection:addComponent("RearWheels",  "wheelsOffsetRear", 	"garage_tuning_config_rear_wheels")
	end
	
	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
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
		local componentName = self.componentsSelection:getSelectedComponentName()
		if not componentName then
			return
		end
		-- Отобразить экран настройки конфигурации
		self.componentsSelection:stop()
				
		local screenClass = ConfigurationScreen
		if componentName == "FrontWheels" or componentName == "RearWheels" then
			screenClass = WheelsScreen
		end
		self.screenManager:showScreen(screenClass(componentName))
	end	
end