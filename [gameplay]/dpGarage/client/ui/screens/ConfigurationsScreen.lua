-- Экран переключения между конфигурациями компонентов
ConfigurationsScreen = Screen:subclass "ConfigurationsScreen"
local screenSize = Vector2(guiGetScreenSize())

function ConfigurationsScreen:init(componentName)
	self.super:init()
	self.componentsSelection = ComponentSelection({
		{name="Suspension", 	camera="suspension", 		locale="garage_tuning_config_suspension"},
		{name="WheelsOffsetF", 	camera="wheelsOffsetFront", locale="garage_tuning_config_front_wheels_offset"},
		{name="WheelsOffsetR", 	camera="wheelsOffsetRear", 	locale="garage_tuning_config_rear_wheels_offset"},
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
		self.screenManager:showScreen(ConfigurationScreen(componentName))
	end	
end