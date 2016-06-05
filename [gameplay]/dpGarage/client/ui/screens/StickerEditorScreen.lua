StickerEditorScreen = Screen:subclass "StickerEditorScreen"

local stickerControlKeys = {"q", "w", "e", "r"}

function StickerEditorScreen:init(sideName)
	self.super:init()
	self.sideName = sideName

	--CameraManager.setState("sideRight", true)
	self.panel = TuningPanel({
		{icon = Assets.textures.stickersMoveIcon, text = exports.dpLang:getString("garage_sticker_editor_move")},
		{icon = Assets.textures.stickersScaleIcon, text = exports.dpLang:getString("garage_sticker_editor_scale")},
		{icon = Assets.textures.stickersRotateIcon, text = exports.dpLang:getString("garage_sticker_editor_rotate")},
		{icon = Assets.textures.stickersColorIcon, text = exports.dpLang:getString("garage_sticker_editor_color")},
	})
end

function StickerEditorScreen:draw()
	self.super:draw()
	self.panel:draw(self.fadeProgress)
end

function StickerEditorScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.panel:update(deltaTime)
end

function StickerEditorScreen:addSticker(id)
	outputDebugString("Add sticker: " .. tostring(id))
end

function StickerEditorScreen:show()
	self.super:show()

	-- TODO: Локализация подсказок
	GarageUI.setHelpText(string.format(
		exports.dpLang:getString("garage_help_sticker_editor"), 
		exports.dpLang:getString("controls_arrows"), 
		"Q", "W", "E", "R", 
		"A", "D",
		"BACKSPACE"
	))	
end

function StickerEditorScreen:hide()
	self.super:hide()

	GarageUI.resetHelpText()
end

function StickerEditorScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_r" then

	elseif key == "arrow_l" then

	elseif key == "arrow_u" then
	
	elseif key == "arrow_d" then
	
	elseif key == "backspace" then
		self.screenManager:showScreen(StickersSideScreen(self.sideName))
	elseif key == "enter" then

	elseif key == "a" then
		self.screenManager:showScreen(StickerSelectionScreen())
	elseif key == "d" then
		-- Удаление наклейки		
	else
		for i, name in ipairs(stickerControlKeys) do
			if key == name then
				self.panel:setActiveItem(i)
			end
		end
	end
end