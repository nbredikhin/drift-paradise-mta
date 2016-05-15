-- Экран выбора компонента

ComponentsMenu = TuningMenu:subclass "ComponentsMenu"

function ComponentsMenu:init(position, rotation, size)
	self.super:init(position, rotation, size)
end

function ComponentsMenu:draw(fadeProgress)
	self.super:draw(fadeProgress)

	dxSetRenderTarget(self.renderTarget, true)
	dxDrawRectangle(0, 0, self.resolution.x, self.resolution.y, tocolor(42, 40, 41))
	dxDrawRectangle(0, 0, self.resolution.x, 70, tocolor(32, 30, 31))
	dxDrawText("Бампер", 0, 0, self.resolution.x, 70, tocolor(255, 255, 255), 1, Assets.fonts.menu, "center", "center")
	dxDrawRectangle(0, self.resolution.y - 70, self.resolution.x, 70, tocolor(212, 0, 40))
	dxDrawText("Установить", 0, self.resolution.y - 70, self.resolution.x, self.resolution.y, tocolor(255, 255, 255), 1, Assets.fonts.menu, "center", "center")
	dxSetRenderTarget()
end

function ComponentsMenu:update(deltaTime)
	self.super:update(deltaTime)
end