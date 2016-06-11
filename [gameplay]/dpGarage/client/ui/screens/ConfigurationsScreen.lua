-- Экран переключения между конфигурациями компонентов
ConfigurationsScreen = Screen:subclass "ConfigurationsScreen"
local screenSize = Vector2(guiGetScreenSize())

function ConfigurationsScreen:init(componentName)
	self.super:init()
	self.componentsSelection = ComponentSelection({
		{name="Suspension", 	camera="suspension", 		locale="garage_tuning_config_suspension"},
		{name="FrontWheels", 	camera="wheelsOffsetFront", locale="garage_tuning_config_front_wheels"},
		{name="RearWheels", 	camera="wheelsOffsetRear", 	locale="garage_tuning_config_rear_wheels"},
		{name="WheelsSize", 	camera="wheelsSize", 		locale="garage_tuning_config_wheels_size"},
	})
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
		-- Отобразить экран настройки конфигурации
		self.componentsSelection:stop()
		local componentName = self.componentsSelection:getSelectedComponentName()
		local screenClass = ConfigurationScreen
		if componentName == "FrontWheels" or componentName == "RearWheels" then
			screenClass = WheelsScreen
		end
		self.screenManager:showScreen(screenClass(componentName))
	end	
end