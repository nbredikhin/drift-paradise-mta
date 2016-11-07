StickerEditorScreen = Screen:subclass "StickerEditorScreen"

local stickerControlKeys = {
	["q"] = {mode = "move", 	panelItem = 1}, 
	["w"] = {mode = "scale",	panelItem = 2}, 
	["e"] = {mode = "rotate", 	panelItem = 3}, 
	["r"] = {mode = "color", 	panelItem = 4}
}
local bodySides = {
	["Left"] = {reverse = true, ox = 1, oy = -1, px = 890, py = 512, rot = -90},
	["Right"] = {reverse = true, ox = -1, oy = 1, px = 110, py = 512, rot = 90},
	["Top"] = {reverse = false, ox = 1, oy = 1, px = 512, py = 512, rot = 0},
	["Front"] = {reverse = false, ox = 1, oy = 1, px = 512, py = 830, rot = 0},
	["Back"] = {reverse = false, ox = -1, oy = -1, px = 512, py = 150, rot = 180},
}
local STICKER_MOVE_SPEED = 200
local STICKER_SCALE_SPEED = 150
local STICKER_ROTATE_SPEED = 90
local SLOW_SPEED_MUL = 0.2
local FAST_SPEED_MUL = 3

function StickerEditorScreen:init(sideName)
	self.super:init()
	self.sideName = sideName
	self.panel = TuningPanel({
		{icon = Assets.textures.stickersMoveIcon, text = exports.dpLang:getString("garage_sticker_editor_move"), key = "Q"},
		{icon = Assets.textures.stickersScaleIcon, text = exports.dpLang:getString("garage_sticker_editor_scale"), key = "W"},
		{icon = Assets.textures.stickersRotateIcon, text = exports.dpLang:getString("garage_sticker_editor_rotate"), key = "E"},
		{icon = Assets.textures.stickersColorIcon, text = exports.dpLang:getString("garage_sticker_editor_color"), key = "R"},
	})

	self.mode = "move"

	local screenSize = Vector2(exports.dpUI:getScreenSize())
	self.colorPanel = ColorPanel(exports.dpLang:getString("garage_tuning_sticker_color"))
	self.colorPanel.x = -self.colorPanel.resolution.x
	self.colorPanel.y = screenSize.y / 2 - self.colorPanel.resolution.y / 2
	self.colorPanel.showPrice = false
	self.colorPanel.resolution = Vector2(300, 350)
	self.colorPanelX = -self.colorPanel.resolution.x
	self.renderTarget = exports.dpUI:getRenderTarget()

	CarTexture.unselectSticker()
	self.stickerPreview = StickerPreview()
	self:updateSelectedSticker()

	CameraManager.setState("side" .. tostring(sideName), false, 2)

	self.helpPanel = HelpPanel({
		{ keys = {"A"}, locale = "garage_sticker_editor_help_add" },
		{ keys = {"D"}, locale = "garage_sticker_editor_help_remove" },
		{ keys = {"F"}, locale = "garage_sticker_editor_help_clone"},
		{ keys = {"C"}, locale = "garage_sticker_editor_help_copy_style"},
		{ keys = {"Q", "W", "E", "R"}, locale = "garage_sticker_editor_help_change_mode" },
		{ keys = {"ALT", "SHIFT"}, locale = "garage_sticker_editor_help_speed"},
		{ keys = {"CTRL"}, locale = "garage_sticker_editor_help_scale"},
		{ keys = {"controls_arrows"}, locale = "garage_sticker_editor_help_transform" },
		{ keys = {"1", "2"}, locale = "garage_sticker_editor_help_mirroring"},
		{ keys = {"K", "L"}, locale = "garage_sticker_editor_help_next_prev"},		
		{ keys = {"Z"}, locale = "garage_sticker_editor_help_toggle"},
	})
end

function StickerEditorScreen:draw()
	self.super:draw()
	self.panel:draw(self.fadeProgress)
	if CarTexture.getSelectedSticker() then
		dxSetRenderTarget(self.renderTarget)
		self.colorPanel:draw(self.fadeProgress)
		dxSetRenderTarget()
	end

	self.stickerPreview:draw(self.fadeProgress)
	self.helpPanel:draw(self.fadeProgress)
end

function StickerEditorScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.panel:update(deltaTime)
	self.helpPanel:update(deltaTime)
	self.colorPanel.x = self.colorPanel.x + (self.colorPanelX - self.colorPanel.x) * deltaTime * 20

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

		-- Ускорение/замедление движения наклейки
		if getKeyState("lalt") then
			transformX = transformX * SLOW_SPEED_MUL
			transformY = transformY * SLOW_SPEED_MUL
		elseif getKeyState("lshift") then
			transformX = transformX * FAST_SPEED_MUL
			transformY = transformY * FAST_SPEED_MUL
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
		elseif self.mode == "color" then
			if transformX > 0 then
				self.colorPanel:increase(deltaTime)
				local color = tocolor(self.colorPanel:getColor())
				CarTexture.setStickerColor(color)
				self.stickerPreview:setStickerColor(color)
			elseif transformX < 0 then
				self.colorPanel:decrease(deltaTime)
				local color = tocolor(self.colorPanel:getColor())
				CarTexture.setStickerColor(color)
				self.stickerPreview:setStickerColor(color)
			end
		end
	end
end

function StickerEditorScreen:addSticker(id)
	if not CarTexture.canAddSticker() then
		return
	end
	CarTexture.addSticker(id, bodySides[self.sideName].px, bodySides[self.sideName].py, bodySides[self.sideName].rot)
	self:updateSelectedSticker()
	GarageCar.save()
end

function StickerEditorScreen:show()
	self.super:show()

	GarageUI.setHelpText("")
end

function StickerEditorScreen:hide()
	self.super:hide()

	GarageUI.resetHelpText()
	CarTexture.unselectSticker()
	CarTexture.save()
end

function StickerEditorScreen:updateSelectedSticker()
	local sticker = CarTexture.getSelectedSticker()

	if sticker then
		self.stickerPreview:showSticker(sticker[5])
		self.stickerPreview:setStickerColor(CarTexture.getStickerColor())
		local x, y = sticker[1], sticker[2]
		local minDistance = 2048
		local minSide = "Left"
		for name, side in pairs(bodySides) do
			local distance = getDistanceBetweenPoints2D(side.px, side.py, x, y)
			if distance < minDistance then
				minDistance = distance
				minSide = name
			end
		end
		self.sideName = minSide
		CameraManager.setState("side" .. tostring(self.sideName), false, 4)

		local stickerColor = CarTexture.getStickerColor()
		if stickerColor then
			local r, g, b = fromColor(CarTexture.getStickerColor())
			if r then
				self.colorPanel:setColor(r, g, b)		
			end
		end
	else
		self.stickerPreview:hideSticker()
	end
end

function StickerEditorScreen:onKey(key)
	self.super:onKey(key)

	if key == "backspace" then
		GarageCar.save()
		CarTexture.reset()
		self.screenManager:showScreen(StickersSideScreen(self.sideName))
	elseif key == "z" then
		self.helpPanel:toggle()
	elseif key == "1" then
		CarTexture.toggleStickerMirroring()
		exports.dpSounds:playSound("ui_change.wav")
	elseif key == "2" then
		CarTexture.toggleTextMirroring()
		exports.dpSounds:playSound("ui_change.wav")
	elseif key == "enter" then
		CarTexture.unselectSticker()
		self:updateSelectedSticker()
	elseif key == "a" then
		if not CarTexture.canAddSticker() then
			exports.dpSounds:playSound("error.wav")
			return
		end
		self.screenManager:showScreen(StickerSelectionScreen(self.sideName))
		exports.dpSounds:playSound("ui_select.wav")
	elseif key == "d" or key == "delete" then
		CarTexture.removeSticker()
		self:updateSelectedSticker()
		GarageCar.save()
	elseif key == "k" then
		CarTexture.selectPreviousSticker()
		self:updateSelectedSticker()
	elseif key == "l" then
		CarTexture.selectNextSticker()
		self:updateSelectedSticker()
	elseif key == "f" then
		if not CarTexture.canAddSticker() then
			exports.dpSounds:playSound("error.wav")
			return
		end		
		CarTexture.cloneSticker()
		self:updateSelectedSticker()
	else
		for name, v in pairs(stickerControlKeys) do
			if key == name then
				exports.dpSounds:playSound("ui_change.wav")
				self.panel:setActiveItem(v.panelItem)
				self.mode = v.mode

				if self.mode == "color" then
					self.colorPanelX = 20

					local stickerColor = CarTexture.getStickerColor()
					if stickerColor then
						local r, g, b = fromColor(CarTexture.getStickerColor())
						self.colorPanel:setColor(r, g, b)
					end
				else
					self.colorPanelX = -self.colorPanel.resolution.x - 20
				end
			end
		end
	end

	if self.mode == "color" then
		if key == "arrow_u" then
			self.colorPanel:selectPreviousBar()
		elseif key == "arrow_d" then
			self.colorPanel:selectNextBar()
		end
	end
end