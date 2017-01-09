TuningScreen = Screen:subclass "TuningScreen"

function TuningScreen:init(item)
	self.super:init()
	self.panel = TuningPanel({
		{icon = Assets.textures.tuningComponentsIcon, 	text = exports.dpLang:getString("garage_menu_customize_components")},
		{icon = Assets.textures.tuningColorIcon, 		text = exports.dpLang:getString("garage_menu_customize_paint")},
		{icon = Assets.textures.tuningVinylsIcon, 		text = exports.dpLang:getString("garage_menu_customize_stickers")},
		{icon = Assets.textures.tuningSettingsIcon, 	text = exports.dpLang:getString("garage_menu_customize_config")},
	}, true)
	CameraManager.setState("vehicleTuning", false, 2)
	if type(item) == "number" then
		self.panel:setActiveItem(item)
	end
end

function TuningScreen:draw()
	self.super:draw()
	self.panel:draw(self.fadeProgress)
end

function TuningScreen:update(dt)
	self.super:update(dt)
	self.panel:update(dt)
end

function TuningScreen:onKey(key)
	self.super:onKey(key)
	if key == "arrow_l" then
		self.panel:selectPrevious()
	elseif key == "arrow_r" then
		self.panel:selectNext()
	elseif key == "enter" then
		if self.panel:getActiveItem() == 1 then
			self.screenManager:showScreen(ComponentsScreen())
		elseif self.panel:getActiveItem() == 2 then
			self.screenManager:showScreen(ColorsScreen())
		elseif self.panel:getActiveItem() == 3 then
			self.screenManager:showScreen(StickerEditorScreen())
		elseif self.panel:getActiveItem() == 4 then
			self.screenManager:showScreen(ConfigurationsScreen())
		end
	elseif key == "backspace" then
		self.screenManager:showScreen(MainScreen(3))
	end
end