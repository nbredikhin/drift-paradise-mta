-- Экран покупки компонента

ComponentScreen = Screen:subclass "ComponentScreen"

-- Расположение 3D меню для разных компонентов
local menuLocations = {}
menuLocations["FrontBump"] 	= {position = Vector3(2917, -3188.3, 2535.6), 	angle = 30}
menuLocations["Spoilers"] 	= {position = Vector3(2915, -3188.3, 2535.8), 	angle = 185}
menuLocations["RearBump"] 	= {position = Vector3(2915, -3184.2, 2535.6), 	angle = 190}
menuLocations["Wheels"] 	= {position = Vector3(2913.8, -3184.3, 2535.3), angle = 15}
menuLocations["SideSkirts"] = {position = Vector3(2914.3, -3188.6, 2535.3), angle = 10}
menuLocations["RearFends"] 	= {position = Vector3(2916.5, -3188.3, 2535.3), angle = 210}
menuLocations["FrontFends"] = {position = Vector3(2915, -3188.3, 2535.3), 	angle = 0}
menuLocations["Bonnets"] 	= {position = Vector3(2917, -3188.4, 2535.6), 	angle = 20}
menuLocations["Exhaust"] 	= {position = Vector3(2915, -3184.2, 2535.4), 	angle = 190}
menuLocations["RearLights"] = {position = Vector3(2915, -3184.2, 2535.6), 	angle = 190}

function ComponentScreen:init(name)
	self.super:init()
	self.vehicle = GarageCar.getVehicle()
	-- Название компонента, который будет выбираться
	self.componentName = name

	local menuLocation = menuLocations[name]
	-- 3D меню
	self.menu = ComponentsMenu(
		menuLocation.position, 
		menuLocation.angle,
		name,
		TuningConfig.getComponentsCount(self.vehicle.model, self.componentName),
		self.vehicle:getData(name)
	)
	CameraManager.setState("preview" .. name, false, 3)

	self:onItemChanged()
end

function ComponentScreen:hide()
	self.super:hide()
	self.menu:destroy()
end

function ComponentScreen:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
end

function ComponentScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.menu:update(deltaTime)
end

function ComponentScreen:onItemChanged()
	local currentComponentIndex = self.menu:getComponent()
	local componentConfig = TuningConfig.getComponentConfig(
		self.vehicle.model, 
		self.componentName, 
		currentComponentIndex
	)
	-- Обновить цену
	local price = componentConfig.price
	if not price then
		price = 0
	end
	self.menu:setPrice(price)

	-- TODO: Уровень
	
	-- Показать компонент
	GarageCar.previewComponent(self.componentName, currentComponentIndex)
end

function ComponentScreen:onKey(key)
	self.super:onKey(key)
	if key == "backspace" then
		GarageCar.resetTuning()
		self.screenManager:showScreen(ComponentsScreen(self.componentName))
	elseif key == "arrow_u" then
		self.menu:showPrevious()
		self:onItemChanged()
	elseif key == "arrow_d" then
		self.menu:showNext()
		self:onItemChanged()
	elseif key == "enter" then
		if self.menu:canBuyCurrentComponent() then
			GarageCar.applyComponent(self.componentName, self.menu:getComponent())
			self.screenManager:showScreen(ComponentsScreen(self.componentName))
		end
	end
end