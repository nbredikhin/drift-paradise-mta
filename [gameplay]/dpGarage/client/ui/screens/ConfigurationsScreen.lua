-- Экран переключения между конфигурациями компонентов
ConfigurationsScreen = Screen:subclass "ConfigurationsScreen"
local screenSize = Vector2(guiGetScreenSize())

local configurationsList = {
	{
		locale = "garage_tuning_config_suspension",
		offset = {0.1, 0, 0},
		data = "Suspension",
		camera = "suspension"
	},
	{
		locale = "garage_tuning_config_front_wheels_offset",
		offset = {0.1, 0, 0},
		data = "WheelsOffsetF",
		camera = "wheelsOffsetFront"
	},
	{
		locale = "garage_tuning_config_rear_wheels_offset",
		offset = {0.1, 0, 0},
		data = "WheelsOffsetR",
		camera = "wheelsOffsetRear"
	},	
}

function ConfigurationsScreen:showConfiguration()
	self.currentConfiguration = configurationsList[self.currentConfigurationIndex]
	self.configurationName = exports.dpLang:getString(self.currentConfiguration.locale)
	CameraManager.setState(self.currentConfiguration.camera, false, 4)
	self.componentNameText:changeText(self.configurationName)
end

function ConfigurationsScreen:init(forceIndex)
	self.super:init()
	self.currentConfigurationIndex = 1
	if type(forceIndex) == "number" then
		self.currentConfigurationIndex = forceIndex
	end
	self.componentNameText = ComponentNameText()
	self:showConfiguration()
end

function ConfigurationsScreen:draw()
	self.super:draw()
	self.componentNameText:draw(self.fadeProgress)
end

function ConfigurationsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentNameText:update(deltaTime)
end

function ConfigurationsScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		-- Перейти к следующему компоненту
		self.currentConfigurationIndex = self.currentConfigurationIndex + 1
		if self.currentConfigurationIndex > #configurationsList then
			self.currentConfigurationIndex = 1
		end
		self:showConfiguration()
	elseif key == "arrow_l" then
		-- Перейти к предыдущему компоненту
		self.currentConfigurationIndex = self.currentConfigurationIndex - 1
		if self.currentConfigurationIndex < 1 then
			self.currentConfigurationIndex = #configurationsList
		end
		self:showConfiguration()
	elseif key == "backspace" then
		-- Вернуться на предыдущий экран
		self.screenManager:showScreen(TuningScreen(4))
		GarageUI.showSaving()
		GarageCar.save()
	elseif key == "enter" then
		-- Отобразить экран настройки конфигурации
		self.screenManager:showScreen(ConfigurationScreen(self.currentConfiguration.data, self.currentConfigurationIndex))
	end	
end