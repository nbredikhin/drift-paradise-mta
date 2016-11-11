-- Экран переключения между компонентами
ComponentsScreen = Screen:subclass "ComponentsScreen"
local screenSize = Vector2(guiGetScreenSize())

-- componentName - название компонента, который нужно отобразить при переходе на экран
function ComponentsScreen:init(componentName)
	self.super:init()
	local numberplateInfo = exports.dpShared:getTuningPrices("numberplate")
	local componentsList = {
		{name="FrontBump", 	camera="frontBump", 	locale="garage_tuning_component_front_bump", animate={component="FrontBump%u", 		offset=Vector3(0, 0.1, 0)}},
		{name="WheelsF", 	camera="wheelLF", 		locale="garage_tuning_component_wheels_front"},
		{name="WheelsR", 	camera="wheelLB", 		locale="garage_tuning_component_wheels_rear"},
		{name="RearBump", 	camera="rearBump", 		locale="garage_tuning_component_rear_bump",	 animate={component="RearBump%u", 		offset=Vector3(0, -0.1, 0)}},
		{name="Exhaust", 	camera="exhaust", 		locale="garage_tuning_component_exhaust",	 animate={component="Exhaust%u", 		offset=Vector3(0, 0.05, 0)}},
		{name="RearLights", camera="rearLights", 	locale="garage_tuning_component_rear_lights"},
		{name="Spoilers", 	camera="spoiler", 		locale="garage_tuning_component_spoilers"},
		{name="RearFends", 	camera="rearFends", 	locale="garage_tuning_component_rear_fends", animate={component="RearFends%u", 		offset=Vector3(0.05, 0, 0)}},
		{name="SideSkirts", camera="skirts", 		locale="garage_tuning_component_side_skirts",animate={component="SideSkirts%u", 	offset=Vector3(0.1, 0, 0)}},
		{name="FrontFends", camera="frontFends", 	locale="garage_tuning_component_front_fends",animate={component="FrontFends%u", 	offset=Vector3(0.05, 0, 0)}},
		{name="Bonnets", 	camera="bonnet", 		locale="garage_tuning_component_bonnet",	 animate={component="Bonnets%u", 		offset=Vector3(0, 0, 0.05)}},
		{name="FrontLights",camera="frontLights", 	locale="garage_tuning_component_front_lights"},
		{name="Numberplate",camera="numberplate", 	locale="garage_tuning_component_numberplate", price = numberplateInfo[1], level = numberplateInfo[2]},
	}
	local vehicle = GarageCar.getVehicle()
	local toRemove = {}
	for i, component in ipairs(componentsList) do
		local count = TuningConfig.getComponentsCount(vehicle.model, component.name)
		if component.name == "Numberplate" then
			count = 1
		end
		if count <= 0 or not GarageCar.hasComponent(component.name) then
			table.insert(toRemove, i)
		end
	end
	for i = #toRemove, 1, -1 do
		table.remove(componentsList, toRemove[i])
	end

	self.componentsSelection = ComponentSelection(componentsList)

	-- Если возвращаемся, показать компонент, с которого возвращаемся
	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
end

function ComponentsScreen:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function ComponentsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function ComponentsScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		self.componentsSelection:stop()
		self.screenManager:showScreen(TuningScreen(1))
		GarageCar.save()
	elseif key == "enter" then
		if not self.componentsSelection:canBuy() then
			return
		end
		self.componentsSelection:stop()
		local componentName = self.componentsSelection:getSelectedComponentName()		
		if componentName == "Numberplate" then
			self.screenManager:showScreen(NumberplateScreen())
		else
			self.screenManager:showScreen(ComponentScreen(componentName))
		end
	end
end