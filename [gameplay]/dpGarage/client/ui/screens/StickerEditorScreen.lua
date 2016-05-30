StickerEditorScreen = Screen:subclass "StickerEditorScreen"

local stickerControlKeys = {"w", "e", "r", "t"}

function StickerEditorScreen:init(sideName)
	self.super:init()

	--CameraManager.setState("sideRight", true)
	self.controlsMenu = StickersControlsMenu()
end

function StickerEditorScreen:draw()
	self.super:draw()
	self.controlsMenu:draw(self.fadeProgress)
end

function StickerEditorScreen:update(deltaTime)
	self.super:update(deltaTime)
end

function StickerEditorScreen:show()
	self.super:show()

	-- TODO: Локализация подсказок
	GarageUI.setHelpText("Стрелки - управление, A - добавить наклейку, D - удалить, BACKSPACE - назад")
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
		self.screenManager:showScreen(StickersSideScreen())
	elseif key == "enter" then

	elseif key == "a" then
		self.screenManager:showScreen(StickerSelectionScreen())
	elseif key == "d" then
		-- Удаление наклейки		
	else
		for i, name in ipairs(stickerControlKeys) do
			if key == name then
				self.controlsMenu.selectedItem = i
			end
		end
	end
end