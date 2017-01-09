StickerSelectionScreen = Screen:subclass "StickerSelectionScreen"

function StickerSelectionScreen:init(sideName)
	self.super:init()	
	self.stickersGrid = StickersGrid()
	self.sideName = sideName
end

function StickerSelectionScreen:show()
	self.super:show()	
	GarageUI.setHelpText(string.format(
		exports.dpLang:getString("garage_help_sticker_selection"), 
		exports.dpLang:getString("controls_arrows"), 
		"ENTER", 
		"BACKSPACE"
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
		local screen = StickerEditorScreen(true)
		local sticker = self.stickersGrid:getSelectedSticker()
		if not sticker then
			return 
		end
		Garage.buy(sticker.price, sticker.level, function(success)
			if success then
				self.screenManager:showScreen(screen)
				if sticker and sticker.id then
					screen:addSticker(sticker.id)
				end				
			end			
		end)
	elseif key == "backspace" then
		self.screenManager:showScreen(StickerEditorScreen(true))
	end

	self.stickersGrid:onKey(key)
end