StickerSelectionScreen = Screen:subclass "StickerSelectionScreen"

function StickerSelectionScreen:init(sideName)
	self.super:init()
	self.stickersGrid = StickersGrid()
end

function StickerSelectionScreen:show()
	self.super:show()
	"Стрелки - выбор, ENTER - купить, BACKSPACE - отмена")
	GarageUI.setHelpText(string.format(
		exports.dpLang:getString("garage_help_text"), 
		exports.dpLang:getString("controls_arrows"), 
		"ENTER", 
		"BACKSPACE",
		exports.dpLang:getString("controls_mouse")
	))
end

function StickerSelectionScreen:hide()
	self.super:hide()
	GarageUI.resetHelpText()
	self.stickersGrid:destroy()
end

function StickerSelectionScreen:draw()
	self.super:draw()
	self.stickersGrid:draw(self.fadeProgress)
end

function StickerSelectionScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.stickersGrid:update(deltaTime)
end

function StickerSelectionScreen:onKey(key)
	self.super:onKey(key)

	if key == "enter" then
		local screen = StickerEditorScreen(self.sideName)
		local sticker = self.stickersGrid:getSelectedSticker()
		if sticker and sticker.id then
			screen:addSticker(sticker.id)
		end
		self.screenManager:showScreen(screen)
	elseif key == "backspace" then
		self.screenManager:showScreen(StickerEditorScreen(self.sideName))
	end

	self.stickersGrid:onKey(key)
end