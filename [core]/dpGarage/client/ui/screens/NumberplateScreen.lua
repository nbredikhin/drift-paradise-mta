-- Экран смены номерного знака

NumberplateScreen = Screen:subclass "NumberplateScreen"

local MAX_NUMBERPLATE_TEXT_LENGTH = 10

local allowedLetters = "abcdefghijklmnopqrstuvwxyz0123456789"

function NumberplateScreen:init()
	self.super:init()

	self.numberplateText = GarageCar.getVehicle():getData("Numberplate")
	if type(self.numberplateText) ~= "string" then
		self.numberplateText = "unknown"
	end
	CameraManager.setState("previewNumberplate", false, 3)
	guiSetInputMode("no_binds")
end

function NumberplateScreen:draw()
	self.super:draw()
end

function NumberplateScreen:show()
	self.super:show()
	guiSetInputEnabled(true)
	GarageUI.setHelpText(string.format(
		exports.dpLang:getString("garage_help_numberplate"), 
		"DELETE", 
		"ENTER",
		"BACKSPACE"
	))		
end

function NumberplateScreen:hide()
	self.super:hide()
	guiSetInputEnabled(false)
	GarageUI.resetHelpText()
end

function NumberplateScreen:updateText()
	self.numberplateText = string.sub(self.numberplateText, 1, MAX_NUMBERPLATE_TEXT_LENGTH)
	GarageCar.previewTuning("Numberplate", self.numberplateText)
end

function NumberplateScreen:onKey(key)
	self.super:onKey(key)

	if key == "enter" then
		local this = self
		local price, level = unpack(exports.dpShared:getTuningPrices("numberplate"))
		Garage.buy(price, level, function(success)	
			if success then
				GarageCar.applyTuning("Numberplate", this.numberplateText)
			else
				GarageCar.resetTuning()
			end
			this.screenManager:showScreen(ComponentsScreen("Numberplate"))
		end)
	elseif key == "backspace" then
		if string.len(self.numberplateText) > 0 then
			self.numberplateText = string.sub(self.numberplateText, 1, -2)
			self:updateText()
		else
			GarageCar.resetTuning()
			self.screenManager:showScreen(ComponentsScreen("Numberplate"))
		end
	elseif key == "space" then
		self.numberplateText = self.numberplateText .. " "
		self:updateText()
	else
		if string.find(allowedLetters, key) then
			self.numberplateText = self.numberplateText .. key			
			self:updateText()
		end
	end
end