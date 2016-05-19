TuningScreen = Screen:subclass "TuningScreen"

function TuningScreen:init(forceItem)
	self.super:init()
	self.menu = ItemsMenu(
		{
			"garage_menu_customize_components",
			"garage_menu_customize_paint",
			"garage_menu_customize_stickers",
			"garage_menu_customize_config",
			"garage_menu_back"
		},
		Vector3(2917.5, -3183.7, 2535.6), 
		-10,
		forceItem
	)	
	CameraManager.setState("vehicleTuning", false, 2)
end

function TuningScreen:show()
	self.super:show()
end

function TuningScreen:hide()
	self.super:hide()
	self.menu:destroy()
end

function TuningScreen:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
end

function TuningScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.menu:update(deltaTime)
end

function TuningScreen:onKey(key)
	self.super:onKey(key)
	self.menu:onKey(key)

	if key == "enter" then
		if self.menu:getItem() == "garage_menu_customize_components" then
			self.screenManager:showScreen(ComponentsScreen())
		elseif self.menu:getItem() == "garage_menu_customize_paint" then
		elseif self.menu:getItem() == "garage_menu_customize_stickers" then
		elseif self.menu:getItem() == "garage_menu_customize_config" then
			self.screenManager:showScreen(ConfigurationsScreen())
		elseif self.menu:getItem() == "garage_menu_back" then
			self.screenManager:showScreen(MainScreen())
		end		
	elseif key == "backspace" then
		self.screenManager:showScreen(MainScreen())
	end
end