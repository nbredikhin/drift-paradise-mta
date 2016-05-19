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

	-- if self.currentComponent.num then
	-- 	local id = self.vehicle:getData(self.componentName)
	-- 	if not id then
	-- 		id = 0
	-- 	end
	-- 	self.componentName = self.componentName .. tostring(id)
	-- end

	-- self.componentPosition = {self.vehicle:getComponentPosition(self.componentName)}
	-- if not self.componentPosition[1] then
	-- 	self.componentPosition = {0, 0, 0}
	-- end
	CameraManager.setState(self.currentConfiguration.camera, false, 4)
	self.t = 0
end

function ConfigurationsScreen:init(forceIndex)
	self.super:init()
	self.t = 0
	self.currentConfigurationIndex = 1
	if type(forceIndex) == "number" then
		self.currentConfigurationIndex = forceIndex
	end
	self:showConfiguration()
end

function ConfigurationsScreen:show()
	self.super:show()
end

function ConfigurationsScreen:hide()
	self.super:hide()
end

function ConfigurationsScreen:draw()
	self.super:draw()
	local color = tocolor(255, 255, 255, 255 * self.fadeProgress)--, math.max(0, self.currentAnim * 255 - 55) * self.fadeProgress)
	dxDrawText(self.configurationName, screenSize.x / 2, screenSize.y - 100, screenSize.x / 2, screenSize.y, color, 1, Assets.fonts.componentName, "center", "center")	
end

function ConfigurationsScreen:update(deltaTime)
	self.super:update(deltaTime)
end

function ConfigurationsScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.currentConfigurationIndex = self.currentConfigurationIndex + 1
		if self.currentConfigurationIndex > #configurationsList then
			self.currentConfigurationIndex = 1
		end
		self:showConfiguration()
	elseif key == "arrow_l" then
		self.currentConfigurationIndex = self.currentConfigurationIndex - 1
		if self.currentConfigurationIndex < 1 then
			self.currentConfigurationIndex = #configurationsList
		end
		self:showConfiguration()
	elseif key == "backspace" then
		self.screenManager:showScreen(TuningScreen(4))
		GarageUI.showSaving()
		GarageCar.save()
	elseif key == "enter" then
		self.screenManager:showScreen(ConfigurationScreen(self.currentConfiguration.data, self.currentConfigurationIndex))
	end	
end