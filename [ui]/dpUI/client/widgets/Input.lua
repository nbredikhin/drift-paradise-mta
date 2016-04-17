Input = {}
local activeInput
local repeatTimer
local repeatStartTimer
local MASKED_CHAR = "●"
local REPEAT_WAIT = 500
local REPEAT_DELAY = 50

function Input.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	local widget = Rectangle.create(properties)
	widget._type = "Input"
	widget.placeholder = exports.dpUtils:defaultValue(properties.placeholder, "")
	widget.forceRegister = exports.dpUtils:defaultValue(properties.forceRegister, false)
	widget.masked = exports.dpUtils:defaultValue(properties.masked, false)
	widget.font = Fonts.lightSmall
	widget.regexp = exports.dpUtils:defaultValue(properties.regexp, false)
	local textOffsetX = 10
	function widget:draw()
		if activeInput == self then
			self.color = self.colors.active
		else
			if isPointInRect(self.mouseX, self.mouseY, 0, 0, self.width, self.height) then
				if getKeyState("mouse1") then
					self.color = self.colors.active
				else
					self.color = self.colors.hover
				end
			else		
				self.color = self.colors.normal
			end
		end
		-- Background
		Drawing.rectangle(self.x, self.y, self.width, self.height)

		-- Placeholder
		local text = self.placeholder
		Drawing.setColor(Colors.color("white", 80))
		if string.len(self.text) > 0 then
			text = self.text
			Drawing.setColor(Colors.color("white", 150))
			if self.masked then
				text = ""
				for i = 1, string.len(self.text) do
					text = text .. MASKED_CHAR
				end
			end
		end
		Drawing.text(
			self.x + textOffsetX, 
			self.y, 
			self.width - textOffsetX * 2, 
			self.height, 
			text, 
			"left", 
			"center", 
			true, 
			false
		)
	end	
	return widget
end

addEvent("_dpUI.clickInternal", false)
addEventHandler("_dpUI.clickInternal", resourceRoot, function ()
	if Render.clickedWidget and Render.clickedWidget._type == "Input" then
 		activeInput = Render.clickedWidget
 	else
 		activeInput = nil
 	end

 	guiSetInputMode("no_binds")
 	guiSetInputEnabled(not not activeInput)
end)

local function handleKey(key, repeatKey)
	if not activeInput then
		return 
	end
	if key == "backspace" then
		activeInput.text = string.sub(activeInput.text, 1, -2)
	elseif key == "tab" then
		local inputs = {}
		local currentIndex = 0
		local index = 0
		for i, v in ipairs(activeInput.parent.children) do				
			if v._type == "Input" then
				index = index + 1
				table.insert(inputs, v)
				if v == activeInput then
					currentIndex = index
				end
			end	
		end
		if #inputs > 1 then
			currentIndex = currentIndex + 1
			if currentIndex > #inputs then
				currentIndex = 1
			end
			activeInput = inputs[currentIndex]
		end
	elseif key == "enter" then
		triggerEvent("dpUI.inputEnter", activeInput.resourceRoot, activeInput.id)
		activeInput = nil
	else
		return
	end

	if repeatKey and getKeyState(key) then
		repeatTimer = setTimer(handleKey, REPEAT_DELAY, 1, key, true)
	end
end
addEventHandler("onClientKey", root, function (key, state)
	if not activeInput or MessageBox.isActive() then
		return
	end
	if not state then
		if isTimer(repeatStartTimer) then
			killTimer(repeatStartTimer)
		end
		if isTimer(repeatTimer) then
			killTimer(repeatTimer)
		end		
		return
	end
	handleKey(key, false)
	repeatStartTimer = setTimer(handleKey, REPEAT_WAIT, 1, key, true)
end)

addEventHandler("onClientCharacter", root, function (character)
	if activeInput and not MessageBox.isActive() then
		if activeInput.forceRegister then
			if activeInput.forceRegister == "lower" then
				character = string.lower(character)
			elseif activeInput.forceRegister == "upper" then
				character = string.upper(character)
			end
		end
		if activeInput.regexp then
			if not pregFind(character, activeInput.regexp) then
				return 
			end
		end
		activeInput.text = activeInput.text .. tostring(character)
	end
end)