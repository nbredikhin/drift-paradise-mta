-- Экран конфигурации компонента
ConfigurationScreen = Screen:subclass "ConfigurationScreen"
local screenSize = Vector2(guiGetScreenSize())

function ConfigurationScreen:init(dataName)
	self.super:init()

	self.menu = ConfigurationMenu()
	self.vehicle = GarageCar.getVehicle()
	self.dataName = dataName
	self.configurationIndex = configurationIndex
end

function ConfigurationScreen:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
end

function ConfigurationScreen:update(deltaTime)
	self.super:update(deltaTime)
	if self.dataName then
		GarageCar.previewTuning(self.dataName, self.menu.currentValue / 3)
	end
end

function ConfigurationScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.menu:increase()
	elseif key == "arrow_l" then
		self.menu:decrease()
	elseif key == "backspace" then
		GarageCar.resetTuning()
		self.dataName = nil
		self.screenManager:showScreen(ConfigurationsScreen(self.dataName))
	elseif key == "enter" then
		GarageCar.applyTuning(self.dataName, self.menu.value / 3)
		self.screenManager:showScreen(ConfigurationsScreen(self.dataName))
	end
end