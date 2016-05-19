-- Экран переключения между компонентами
ComponentsScreen = Screen:subclass "ComponentsScreen"
local screenSize = Vector2(guiGetScreenSize())

-- Список компонентов для тюнинга
local componentsList = {
	-- Название компонента 		Оффсет для анимции 		Название камеры 		Есть ли номер 	Название даты
	{name = "FrontBump", 		offset = {0, 0.1, 0}, 	camera = "frontBump", 	num = true, 	data="FrontBump",	locale="garage_tuning_component_front_bump"},
	{name = "wheel_lf_dummy", 	offset = {-0.1, 0, 0}, 	camera = "wheelLF", 	num = false, 	data="Wheels",		locale="garage_tuning_component_wheels"},
	{name = "RearBump", 		offset = {0, -0.1, 0}, 	camera = "rearBump", 	num = true, 	data="RearBump",	locale="garage_tuning_component_rear_bump"},
	{name = "Exhaust", 			offset = {0, 0.05, 0}, 	camera = "exhaust", 	num = true, 	data="Exhaust",		locale="garage_tuning_component_exhaust"},
	{name = "RearLights", 		offset = {0, 0, 0}, 	camera = "rearLights", 	num = true, 	data="RearLights",	locale="garage_tuning_component_rear_lights"},
	{name = "Spoilers", 		offset = {0.1, 0, 0.1}, camera = "spoiler", 	num = true, 	data="Spoilers",	locale="garage_tuning_component_spoilers"},
	{name = "RearFends", 		offset = {0.05, 0, 0}, 	camera = "rearFends", 	num = true, 	data="RearFends",	locale="garage_tuning_component_rear_fends"},
	{name = "SideSkirts", 		offset = {0.1, 0, 0}, 	camera = "skirts", 		num = true, 	data="SideSkirts",	locale="garage_tuning_component_side_skirts"},
	{name = "FrontFends", 		offset = {0.05, 0, 0}, 	camera = "frontFends", 	num = true, 	data="FrontFends",	locale="garage_tuning_component_front_fends"},
	{name = "Bonnets", 			offset = {0, 0, 0.05}, 	camera = "bonnet", 		num = true, 	data="Bonnets",		locale="garage_tuning_component_bonnet"},
}

function ComponentsScreen:init(forceIndex)
	self.super:init()
	self.vehicle = GarageCar.getVehicle()
	-- Время (для анимации)
	self.t = 0
	-- Включена ли анимация выделенного компонента
	self.animationEnabled = true

	self.currentComponentIndex = 1
	if type(forceIndex) == "number" then
		self.currentComponentIndex = forceIndex
	end
	self:showComponent()

	self.targetAnim = 0
	self.currentAnim = 0
end

function ComponentsScreen:resetComponent()
	if self.componentName and self.componentPosition then
		self.vehicle:resetComponentPosition(self.componentName)
	end
end

-- Переключить вид на компонент с индексом currentComponentIndex
function ComponentsScreen:showComponent()
	self.currentComponent = componentsList[self.currentComponentIndex]
	self.componentName = self.currentComponent.name
	self.localizedComponentName = exports.dpLang:getString(self.currentComponent.locale)
	if self.currentComponent.num then
		local id = self.vehicle:getData(self.componentName)
		if not id then
			id = 0
		end
		self.componentName = self.componentName .. tostring(id)
	end

	self.componentPosition = {self.vehicle:getComponentPosition(self.componentName)}
	if not self.componentPosition[1] then
		self.componentPosition = {0, 0, 0}
	end
	CameraManager.setState(self.currentComponent.camera, false, 4)
	self.t = 0
end

function ComponentsScreen:show()
	self.super:show()
end

function ComponentsScreen:hide()
	self.super:hide()
end

function ComponentsScreen:draw()
	self.super:draw()
	local color = tocolor(255, 255, 255, math.max(0, self.currentAnim * 255 - 55) * self.fadeProgress)
	dxDrawText(self.localizedComponentName, screenSize.x / 2, screenSize.y - 100, screenSize.x / 2, screenSize.y, color, 1, Assets.fonts.componentName, "center", "center")
end

function ComponentsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.t = self.t + deltaTime
	if self.currentComponent and self.animationEnabled then
		local offsetMul = math.cos(self.t * 5)
		local x, y, z = unpack(self.componentPosition)
		x = x + self.currentComponent.offset[1] - self.currentComponent.offset[1] * offsetMul / 2
		y = y + self.currentComponent.offset[2] - self.currentComponent.offset[2] * offsetMul / 2
		z = z + self.currentComponent.offset[3] - self.currentComponent.offset[3] * offsetMul / 2
		self.vehicle:setComponentPosition(self.componentName, x, y, z)
	end

	self.currentAnim = self.currentAnim + (self.targetAnim - self.currentAnim) * deltaTime * 2
	if self.targetAnim == 0 and self.currentAnim < 0.1 then
		self.targetAnim = 1
	end
end

function ComponentsScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self:resetComponent()
		self.currentComponentIndex = self.currentComponentIndex + 1
		if self.currentComponentIndex > #componentsList then
			self.currentComponentIndex = 1
		end
		self:showComponent()
		self.targetAnim = 0
		self.currentAnim = 0
	elseif key == "arrow_l" then
		self:resetComponent()
		self.currentComponentIndex = self.currentComponentIndex - 1
		if self.currentComponentIndex < 1 then
			self.currentComponentIndex = #componentsList
		end
		self:showComponent()
		self.targetAnim = 0
		self.currentAnim = 0
	elseif key == "backspace" then
		self:resetComponent()
		self.animationEnabled = false
		self.screenManager:showScreen(TuningScreen())
		GarageUI.showSaving()
		GarageCar.save()
	elseif key == "enter" then
		self:resetComponent()
		self.animationEnabled = false
		self.screenManager:showScreen(ComponentScreen(self.currentComponent.data, self.currentComponentIndex))
	end
end