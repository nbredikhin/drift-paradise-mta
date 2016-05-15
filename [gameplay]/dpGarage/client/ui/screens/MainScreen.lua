MainScreen = Screen:subclass "MainScreen"

function MainScreen:init()
	self.super:init()
	CameraManager.setState("vehicleSelect", false, 1.2)
end

function MainScreen:show()
	self.super:show()

	self.mainMenu = ItemsMenu(
		{
			"garage_menu_go_city",
			"garage_menu_sell",
			"garage_menu_customize",
			"garage_menu_exit"
		},
		Vector3(2918.4, -3188.340, 2535.6), 
		45
	)
end

function MainScreen:hide()
	self.super:hide()
	self.mainMenu:destroy()
end

function MainScreen:draw()
	self.super:draw()
	self.mainMenu:draw(self.fadeProgress)
end

function MainScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.mainMenu:update(deltaTime)
end

function MainScreen:onKey(key)
	self.super:onKey(key)
	self.mainMenu:onKey(key)
	if key == "enter" then
		if self.mainMenu:getItem() == "garage_menu_go_city" then
			exitGarage(GarageCar.getId())
		elseif self.mainMenu:getItem() == "garage_menu_sell" then

		elseif self.mainMenu:getItem() == "garage_menu_customize" then
			self.screenManager:showScreen(TuningScreen())
		elseif self.mainMenu:getItem() == "garage_menu_exit" then
			self.screenManager:hideScreen()
			exitGarage()
		end
	elseif key == "backspace" then
		self.screenManager:hideScreen()
		exitGarage()
	elseif key == "arrow_l" then
		GarageCar.showPreviousCar()
	elseif key == "arrow_r" then
		GarageCar.showNextCar()
	end
end