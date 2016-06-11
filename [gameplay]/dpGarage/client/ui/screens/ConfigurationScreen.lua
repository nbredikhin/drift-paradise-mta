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
		GarageCar.previewTuning(self.dataName, 0.6 + self.menu.currentValue * 0.16)
	end
	if getKeyState("arrow_r") then
		self.menu:increase(deltaTime)
	elseif getKeyState("arrow_l") then
		self.menu:decrease(deltaTime)	
	end
end

function ConfigurationScreen:onKey(key)
	self.super:onKey(key)
	
	if key == "backspace" then
		GarageCar.resetTuning()
		self.dataName = nil
		self.screenManager:showScreen(ConfigurationsScreen(self.dataName))
	elseif key == "enter" then
		GarageCar.applyTuning(self.dataName, self.menu.value / 3)
		self.screenManager:showScreen(ConfigurationsScreen(self.dataName))
	end
end