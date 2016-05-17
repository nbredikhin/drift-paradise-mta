-- Экран переключения между компонентами
ComponentsScreen = Screen:subclass "ComponentsScreen"

-- Список компонентов для тюнинга
local componentsList = {
	-- Название компонента 		Оффсет для анимции 		Название камеры 		Есть ли номер 	Название даты
	{name = "FrontBump", 		offset = {0, 0.1, 0}, 	camera = "frontBump", 	num = true, 	data="FrontBump"},
	{name = "wheel_lf_dummy", 	offset = {-0.1, 0, 0}, 	camera = "wheelLF", 	num = false, 	data="Wheels"},
	{name = "RearBump", 		offset = {0, -0.1, 0}, 	camera = "rearBump", 	num = true, 	data="RearBump"},
	{name = "Spoilers", 		offset = {0, -0.1, 0}, 	camera = "spoiler", 	num = true, 	data="Spoilers"},
	{name = "SideSkirts", 		offset = {0.1, 0, 0}, 	camera = "skirts", 		num = true, 	data="SideSkirts"},
}

function ComponentsScreen:init(forceIndex)
	self.super:init()
	self.vehicle = GarageCar.getVehicle()
	self.t = 0
	self.animationEnabled = true

	self.currentComponentIndex = 4
	if type(forceIndex) == "number" then
		self.currentComponentIndex = forceIndex
	end
	self:showComponent()
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
	-- TODO: Кружочки
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
	elseif key == "arrow_l" then
		self:resetComponent()
		self.currentComponentIndex = self.currentComponentIndex - 1
		if self.currentComponentIndex < 1 then
			self.currentComponentIndex = #componentsList
		end
		self:showComponent()
	elseif key == "backspace" then
		self:resetComponent()
		self.animationEnabled = false
		self.screenManager:showScreen(TuningScreen())
	elseif key == "enter" then
		self:resetComponent()
		self.animationEnabled = false
		self.screenManager:showScreen(ComponentScreen(self.currentComponent.data, self.currentComponentIndex))
	end
end