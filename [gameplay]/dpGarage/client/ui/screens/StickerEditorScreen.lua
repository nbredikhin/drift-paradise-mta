StickerEditorScreen = Screen:subclass "StickerEditorScreen"

local stickerControlKeys = {"q", "w", "e", "r"}

function StickerEditorScreen:init(sideName)
	self.super:init()
	self.sideName = sideName

	--CameraManager.setState("sideRight", true)
	self.panel = TuningPanel({
		{icon = Assets.textures.stickersMoveIcon, text = "Перемещение"},
		{icon = Assets.textures.stickersScaleIcon, text = "Масштаб"},
		{icon = Assets.textures.stickersRotateIcon, text = "Вращение"},
		{icon = Assets.textures.stickersColorIcon, text = "Цвет"},
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
	GarageUI.setHelpText("Стрелки - управление, Q,W,E,R - выбор режима, A - добавить наклейку, D - удалить, BACKSPACE - назад")
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