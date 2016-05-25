-- Экран переключения между компонентами
ComponentsScreen = Screen:subclass "ComponentsScreen"
local screenSize = Vector2(guiGetScreenSize())

-- componentName - название компонента, который нужно отобразить при переходе на экран
function ComponentsScreen:init(componentName)
	self.super:init()
	local componentsList = {
		{name="FrontBump", 	camera="frontBump", 	locale="garage_tuning_component_front_bump", animate={component="FrontBump%u", 		offset=Vector3(0, 0.1, 0)}},
		{name="Wheels", 	camera="wheelLF", 		locale="garage_tuning_component_wheels",	 animate={component="wheel_lf_dummy", 	offset=Vector3(-0.1, 0, 0)}},
		{name="RearBump", 	camera="rearBump", 		locale="garage_tuning_component_rear_bump",	 animate={component="RearBump%u", 		offset=Vector3(0, -0.1, 0)}},
		{name="Exhaust", 	camera="exhaust", 		locale="garage_tuning_component_exhaust",	 animate={component="Exhaust%u", 		offset=Vector3(0, 0.05, 0)}},
		{name="RearLights", camera="rearLights", 	locale="garage_tuning_component_rear_lights"},
		{name="Spoilers", 	camera="spoiler", 		locale="garage_tuning_component_spoilers"},
		{name="RearFends", 	camera="rearFends", 	locale="garage_tuning_component_rear_fends", animate={component="RearFends%u", 		offset=Vector3(0.05, 0, 0)}},
		{name="SideSkirts", camera="skirts", 		locale="garage_tuning_component_side_skirts",animate={component="SideSkirts%u", 	offset=Vector3(0.1, 0, 0)}},
		{name="FrontFends", camera="frontFends", 	locale="garage_tuning_component_front_fends",animate={component="FrontFends%u", 	offset=Vector3(0.05, 0, 0)}},
		{name="Bonnets", 	camera="bonnet", 		locale="garage_tuning_component_bonnet",	 animate={component="Bonnets%u", 		offset=Vector3(0, 0, 0.05)}},
		{name="FrontLights",camera="frontLights", 	locale="garage_tuning_component_front_lights"},
	}
	local vehicle = GarageCar.getVehicle()
	for i, component in ipairs(componentsList) do
		if TuningConfig.getComponentsCount(vehicle.model, component.name) <= 0 then
			table.remove(componentsList, i)
		end
	end
	outputDebugString(#componentsList)
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
		self.screenManager:showScreen(TuningScreen())
		GarageUI.showSaving()
		GarageCar.save()
	elseif key == "enter" then
		self.componentsSelection:stop()
		local componentName = self.componentsSelection:getSelectedComponentName()
		self.screenManager:showScreen(ComponentScreen(componentName))
	end
end