-- Экран покупки компонента

ComponentScreen = Screen:subclass "ComponentScreen"

-- Расположение 3D меню для разных компонентов
local menuLocations = {}
menuLocations["FrontBump"] 	= {position = Vector3(2917, -3188.3, 2535.6), angle = 30}
menuLocations["Spoilers"] 	= {position = Vector3(2914.6, -3188.3, 2535.8), angle = 185}
menuLocations["RearBump"] 	= {position = Vector3(2915, -3184.2, 2535.6), angle = 190}
menuLocations["Wheels"] 	= {position = Vector3(2914, -3184.2, 2535.3), angle = 25}
menuLocations["SideSkirts"] = {position = Vector3(2914.3, -3188.6, 2535.3), angle = 10}

function ComponentScreen:init(name, componentIndex)
	self.super:init()
	local menuLocation = menuLocations[name]
	self.menu = ComponentsMenu(
		menuLocation.position, 
		menuLocation.angle,
		name
	)
	CameraManager.setState("preview" .. name, false, 3)
	self.componentIndex = componentIndex
end

function ComponentScreen:show()
	self.super:show()
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

function ComponentScreen:onKey(key)
	self.super:onKey(key)
	if key == "backspace" then
		self.screenManager:showScreen(ComponentsScreen(self.componentIndex))
	end
end