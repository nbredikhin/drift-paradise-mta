-- Экран покупки компонента

ComponentScreen = Screen:subclass "ComponentScreen"

function ComponentScreen:init()
	self.super:init()
	self.menu = ComponentsMenu(
		Vector3(2917, -3188.3, 2535.6), 
		30,
		Vector2(1.1, 1.1)
	)
	CameraManager.setState("frontBumpPreview", false, 1.2)
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
		self.screenManager:showScreen(ComponentsScreen())
	end
end