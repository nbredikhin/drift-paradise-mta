ComponentSelection = newclass "ComponentSelection"
local SWITCH_CAMERA_SPEED = 4
local ANIMATION_PROGRESS_SPEED = 5
local ANIMATION_SPEED = 0.005

function ComponentSelection:init(componentsList)
	self.vehicle = GarageCar.getVehicle()
	-- Компонент, выбранный в данный момент
	self.selectedComponent = 1
	-- Переведенное название компонента
	self.localizedComponentName = ""
	-- Отображение названия компонента на экране
	self.componentNameText = ComponentNameText()
	self.animationProgress = 0
	self.animationTarget = 0
	self.animationActive = true

	self.componentsList = {}
	for i, component in ipairs(componentsList) do
		self:addComponent(
			component.name, 
			component.camera, 
			component.locale, 
			component.animate,
			component.price,
			component.level
		)
	end
	-- Отобразить выбранный компонент
	self:updateSelection()

	self.isVisible = true
end

function ComponentSelection:resetAnimation()
	local component = self.componentsList[self.selectedComponent]
	if component and component.animateComponent then
		local dataValue = self.vehicle:getData(component.name)
		if dataValue then
			local componentName = string.format(component.animateComponent, dataValue)
			self.vehicle:resetComponentPosition(componentName)
		end
	end
end

function ComponentSelection:stop()
	self:resetAnimation()
	self.animationActive = false
end

function ComponentSelection:updateSelection()
	local component = self.componentsList[self.selectedComponent]
	if not component then
		return
	end
	-- Название компонента
	if component.locale then
		self.localizedComponentName = exports.dpLang:getString(component.locale)
		self.componentNameText:changeText(self.localizedComponentName, component.price, component.level)
	else
		self.componentNameText:changeText("", component.price, component.level)
	end
	-- Перемещение камеры
	if component.cameraName then
		CameraManager.setState(component.cameraName, false, SWITCH_CAMERA_SPEED)
	end
	self.animationProgress = 0
	self.animationTarget = 1
	self:stopBlinking()
	return true
end

-- Добавить компонент в список
function ComponentSelection:addComponent(name, cameraName, locale, animationSettings, price, level)
	if not name then
		return false
	end
	local component = {}
	component.name = name
	component.cameraName = cameraName
	component.locale = locale
	component.price = price
	component.level = level
	if animationSettings then
		component.animateComponent = animationSettings.component
		component.animationOffset = animationSettings.offset
	end
	table.insert(self.componentsList, component)
	if #self.componentsList == 1 then
		self:showComponentById(1)
	end	
	return true
end

-- Отобразить компонент по названию
function ComponentSelection:showComponentByName(name)
	for i, component in ipairs(self.componentsList) do
		if component.name == name then
			self:showComponentById(i)
			return true
		end
	end
	return false
end

function ComponentSelection:showComponentById(id)
	if type(id) ~= "number" then
		return false
	end
	id = math.max(1, math.min(#self.componentsList, id))
	self:resetAnimation()
	self.selectedComponent = id
	self:updateSelection()
	return true
end

function ComponentSelection:showNextComponent()
	self:resetAnimation()
	self.selectedComponent = self.selectedComponent + 1
	if self.selectedComponent > #self.componentsList then
		self.selectedComponent = 1
	end
	self:updateSelection()
	return true
end

function ComponentSelection:showPreviousComponent()
	self:resetAnimation()
	self.selectedComponent = self.selectedComponent - 1
	if self.selectedComponent < 1 then
		self.selectedComponent = #self.componentsList
	end
	self:updateSelection()
	return true
end

function ComponentSelection:update(deltaTime)
	self.componentNameText:update(deltaTime)

	-- Анимация
	if self.animationActive then
		local component = self.componentsList[self.selectedComponent]
		if component and component.animateComponent then
			local dataValue = self.vehicle:getData(component.name)
			if dataValue then
				local animationMul = (math.sin(getTickCount() * ANIMATION_SPEED) + 1) / 2 * self.animationProgress
				local componentName = string.format(component.animateComponent, dataValue)
				self.vehicle:resetComponentPosition(componentName)
				local x, y, z = self.vehicle:getComponentPosition(componentName)
				if x then			
					x = x + component.animationOffset.x * animationMul
					y = y + component.animationOffset.y * animationMul
					z = z + component.animationOffset.z * animationMul
					self.vehicle:setComponentPosition(componentName, x, y, z)
				end
			end
		end
		self.animationProgress = self.animationProgress + (self.animationTarget - self.animationProgress) * deltaTime * ANIMATION_PROGRESS_SPEED
	end
end

function ComponentSelection:draw(fadeProgress)
	if not self.isVisible then
		return
	end
	self.componentNameText:draw(fadeProgress)
end

function ComponentSelection:getSelectedComponentName()
	local component = self.componentsList[self.selectedComponent]
	if not component then
		return false
	end
	return component.name
end

function ComponentSelection:getSelectedComponentPriceLevel()
	local component = self.componentsList[self.selectedComponent]
	if not component then
		return false
	end
	return component.price, component.level
end

function ComponentSelection:blink()
	if not self.isVisible or isTimer(self.blinkTimer) then
		return
	end
	local this = self
	self.blinkTimer = setTimer(function ()
		this.isVisible = not this.isVisible
	end, 200, 8)
end

function ComponentSelection:stopBlinking()
	if isTimer(self.blinkTimer) then
		killTimer(self.blinkTimer)
		self.isVisible = true
	end
end

function ComponentSelection:canBuy()
	local price, level = self:getSelectedComponentPriceLevel()
	if level and level > localPlayer:getData("level") then
		self:blink()
		return false
	end
	if price and price > localPlayer:getData("money") then
		self:blink()
		return false
	end
	return true
end