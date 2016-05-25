ColorScreen = Screen:subclass "ColorScreen"

local colorMenus = {
	["BodyColor"]    = {locale="garage_tuning_paint_body",    position = Vector3(2916, -3188.8, 2535.6),   angle = 10},
	["WheelsColor"]  = {locale="garage_tuning_paint_wheels",  position = Vector3(2913.8, -3184.3, 2535.4), angle = 15},
	["SpoilerColor"] = {locale="garage_tuning_paint_spoiler", position = Vector3(2915, -3188.3, 2535.8),   angle = 185}
}

function ColorScreen:init(componentName)
	self.super:init()
	self.componentName = componentName
	local menuInfo = colorMenus[componentName]
	self.colorMenu = ColorMenu(exports.dpLang:getString(menuInfo.locale), menuInfo.position, menuInfo.angle)
	local color = GarageCar.getVehicle():getData(componentName)
	if color then
		self.colorMenu:setColor(unpack(color))
	end
	self.colorPreviewEnabled = true
	CameraManager.setState("selecting" .. componentName, false, 3)
end

function ColorScreen:hide()
	self.super:hide()
	self.colorMenu:destroy()
end

function ColorScreen:draw()
	self.super:draw()
	self.colorMenu:draw(self.fadeProgress)
end

function ColorScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.colorMenu:update(deltaTime)

	if getKeyState("arrow_r") then
		self.colorMenu:increase(deltaTime)
	elseif getKeyState("arrow_l") then
		self.colorMenu:decrease(deltaTime)
	end
	if self.colorPreviewEnabled then
		GarageCar.previewTuning(self.componentName, {self.colorMenu:getColor()})
	end
end

function ColorScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_u" then
		self.colorMenu:selectPreviousBar()
	elseif key == "arrow_d" then
		self.colorMenu:selectNextBar()
	elseif key == "backspace" then
		self.colorPreviewEnabled = false
		GarageCar.resetTuning()
		self.screenManager:showScreen(ColorsScreen(self.componentName))
	elseif key == "enter" then
		self.colorPreviewEnabled = false
		GarageCar.applyTuning(self.componentName, {self.colorMenu:getColor()})
		self.screenManager:showScreen(ColorsScreen(self.componentName))
	end
end