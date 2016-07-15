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
		if self.dataName == "Suspension" then
			GarageCar.previewHandling("Suspension", 0.7 + self.menu.currentValue * 0.3)
		else
			GarageCar.previewTuning(self.dataName, 0.5 + self.menu.currentValue * 0.26)
		end
	end
	if getKeyState("arrow_r") then
		self.menu:increase(deltaTime)
		self.vehicle.velocity = Vector3(0, 0, 0.01)
	elseif getKeyState("arrow_l") then
		self.menu:decrease(deltaTime)
		self.vehicle.velocity = Vector3(0, 0, -0.01)
	end
end

function ConfigurationScreen:onKey(key)
	self.super:onKey(key)
	
	if key == "backspace" then
		GarageCar.resetTuning()
		self.dataName = nil
		self.screenManager:showScreen(ConfigurationsScreen(self.dataName))
	elseif key == "enter" then
		if self.dataName == "Suspension" then
			GarageCar.applyHandling("Suspension")
		else
			GarageCar.applyTuning(self.dataName)
		end
		GarageCar.save()
		self.screenManager:showScreen(ConfigurationsScreen(self.dataName))
	end
end