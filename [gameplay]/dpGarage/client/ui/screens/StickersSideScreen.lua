StickersSideScreen = Screen:subclass "StickersSideScreen"

-- componentName - название компонента, который нужно отобразить при переходе на экран
function StickersSideScreen:init(componentName)
	self.super:init()
	self.componentsSelection = ComponentSelection({
		{name="Front", 	camera="sideFront", locale="garage_tuning_side_front"},
		{name="Left", 	camera="sideLeft", 	locale="garage_tuning_side_left"},
		{name="Back", 	camera="sideBack", 	locale="garage_tuning_side_back"},
		{name="Top", 	camera="sideTop", 	locale="garage_tuning_side_top"},
		{name="Right", 	camera="sideRight", locale="garage_tuning_side_right"},
	})

	-- Если возвращаемся, показать компонент, с которого возвращаемся
	if componentName then
		self.componentsSelection:showComponentByName(componentName)
	end
end

function StickersSideScreen:draw()
	self.super:draw()
	self.componentsSelection:draw(self.fadeProgress)
end

function StickersSideScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.componentsSelection:update(deltaTime)
end

function StickersSideScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then
		self.componentsSelection:showNextComponent()
	elseif key == "arrow_l" then
		self.componentsSelection:showPreviousComponent()
	elseif key == "backspace" then
		self.componentsSelection:stop()
		self.screenManager:showScreen(TuningScreen())
		GarageCar.save()
	elseif key == "enter" then
		self.componentsSelection:stop()
		local componentName = self.componentsSelection:getSelectedComponentName()
		--self.screenManager:showScreen(ComponentScreen(componentName))
	end
end