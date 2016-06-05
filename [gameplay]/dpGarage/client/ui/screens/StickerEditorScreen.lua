StickerEditorScreen = Screen:subclass "StickerEditorScreen"

local stickerControlKeys = {
	["q"] = {mode = "move", 	panelItem = 1}, 
	["w"] = {mode = "scale",	panelItem = 2}, 
	["e"] = {mode = "rotate", 	panelItem = 3}, 
	["r"] = {mode = "color", 	panelItem = 4}
}
local bodySides = {
	["left"] = {reverse = true, ox = 1, oy = -1, px = 890, py = 512, rot = -90},
	["right"] = {reverse = true, ox = -1, oy = 1, px = 110, py = 512, rot = 90},
}
local STICKER_MOVE_SPEED = 200
local STICKER_SCALE_SPEED = 150
local STICKER_ROTATE_SPEED = 90

function StickerEditorScreen:init(sideName)
	self.super:init()
	self.sideName = string.lower(sideName)
	outputDebugString("sideName: " .. tostring(sideName))
	--CameraManager.setState("sideRight", true)
	self.panel = TuningPanel({
		{icon = Assets.textures.stickersMoveIcon, text = exports.dpLang:getString("garage_sticker_editor_move")},
		{icon = Assets.textures.stickersScaleIcon, text = exports.dpLang:getString("garage_sticker_editor_scale")},
		{icon = Assets.textures.stickersRotateIcon, text = exports.dpLang:getString("garage_sticker_editor_rotate")},
		{icon = Assets.textures.stickersColorIcon, text = exports.dpLang:getString("garage_sticker_editor_color")},
	})

	self.mode = "move"
end

function StickerEditorScreen:draw()
	self.super:draw()
	self.panel:draw(self.fadeProgress)
end

function StickerEditorScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.panel:update(deltaTime)

	if not isMTAWindowActive() then
		local transformX = 0
		local transformY = 0
		if getKeyState("arrow_r") then
			transformX = 1
		elseif getKeyState("arrow_l") then 
			transformX = -1
		end
		if getKeyState("arrow_u") then 
			transformY = -1
		elseif getKeyState("arrow_d") then 
			transformY = 1
		end

		if self.mode == "move" then
			if bodySides[self.sideName].reverse then
				transformX, transformY = transformY, transformX
			end
			transformX = transformX * bodySides[self.sideName].ox
			transformY = transformY * bodySides[self.sideName].oy			
			CarTexture.moveSticker(
				transformX * STICKER_MOVE_SPEED * deltaTime, 
				transformY * STICKER_MOVE_SPEED * deltaTime
			)
		elseif self.mode == "scale" then
			if getKeyState("lctrl") then
				CarTexture.resizeSticker(
					transformX * STICKER_SCALE_SPEED * deltaTime, 
					transformY * STICKER_SCALE_SPEED * deltaTime
				)
			else
				CarTexture.resizeSticker(
					transformY * STICKER_SCALE_SPEED * deltaTime, 
					transformY * STICKER_SCALE_SPEED * deltaTime
				)
			end
		elseif self.mode == "rotate" then
			CarTexture.rotateSticker(
				transformX * STICKER_ROTATE_SPEED * deltaTime
			)
		end
	end
end

function StickerEditorScreen:addSticker(id)
	CarTexture.addSticker(id, bodySides[self.sideName].px, bodySides[self.sideName].py, bodySides[self.sideName].rot)
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

	if key == "backspace" or key == "enter" then
		CarTexture.save()
		CarTexture.reset()
		self.screenManager:showScreen(StickersSideScreen(self.sideName))
	elseif key == "a" then
		self.screenManager:showScreen(StickerSelectionScreen(self.sideName))
	elseif key == "d" then
		-- Удаление наклейки		
	else
		for name, v in pairs(stickerControlKeys) do
			if key == name then
				self.panel:setActiveItem(v.panelItem)
				self.mode = v.mode
			end

		end
	end
end