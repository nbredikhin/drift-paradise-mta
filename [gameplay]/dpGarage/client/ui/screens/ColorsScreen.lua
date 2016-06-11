ColorsScreen = Screen:subclass "ColorsScreen"

function ColorsScreen:init(componentName)
	self.super:init()
	self.componentsSelection = ComponentSelection({
		{name="BodyColor", 		camera="bodyColor", 	locale="garage_tuning_paint_body"},
	})
	local vehicle = GarageCar.getVehicle()
	-- Если на машине установлены передние диски
	if vehicle:getData("WheelsF") and vehicle:getData("WheelsF") > 0 then
		self.componentsSelection:addComponent("WheelsColorF", "wheelLF", "garage_tuning_paint_wheels_front")
	end
	-- Если на машине установлены задние диски
	if vehicle:getData("WheelsR") and vehicle:getData("WheelsR") > 0 then
		self.componentsSelection:addComponent("WheelsColorR", "wheelLB", "garage_tuning_paint_wheels_rear")
	end

	-- Если на машине установлен спойлер
	if vehicle:getData("Spoilers") and vehicle:getData("Spoilers") > 0 then
		self.componentsSelection:addComponent("SpoilerColor", "spoiler", "garage_tuning_paint_spoiler")
	end

	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
end

function ColorsScreen:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function ColorsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function ColorsScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		self.componentsSelection:stop()
		self.screenManager:showScreen(TuningScreen(2))
		GarageUI.showSaving()
		GarageCar.save()
	elseif key == "enter" then
		self.componentsSelection:stop()
		local componentName = self.componentsSelection:getSelectedComponentName()
		self.screenManager:showScreen(ColorScreen(componentName))
	end
end