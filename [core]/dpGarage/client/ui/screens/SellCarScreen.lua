SellCarScreen = Screen:subclass "SellCarScreen"
local screenSize = Vector2(guiGetScreenSize())

function SellCarScreen:init(callback)
	self.super:init()
	self.fadeSpeed = 4
	self.canSell = true
	self.text = exports.dpLang:getString("garage_sell_text")
	self.back = utf8.fold(exports.dpLang:getString("garage_menu_back"))
	self.confirm = exports.dpLang:getString("garage_sell_confirm")

	-- if GarageCar.getCarsCount() <= 1 then
	-- 	self.canSell = false
	-- 	self.text = exports.dpLang:getString("garage_sell_last_car")
	-- end

	-- local mileage = GarageCar.getMileage()

	self.colorHex = exports.dpUtils:RGBToHex(exports.dpUI:getThemeColor())
end

function SellCarScreen:show()
	self.super:show()
	GarageUI.setHelpText("")
end

function SellCarScreen:hide()
	self.super:hide()
	GarageUI.resetHelpText()
end

function SellCarScreen:draw()
	self.super:draw()
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 150 * self.fadeProgress))
	local text = self.text
	dxDrawText(
		text,
		0, 0,
		screenSize.x, screenSize.y * 0.5,
		tocolor(255, 255, 255, 255 * self.fadeProgress),
		1,
		Assets.fonts.componentName,
		"center",
		"bottom",
		false, false, false, true
	)

	local confirmText = self.colorHex .. "Backspace #FFFFFF- " .. self.back
	if self.canSell  then
		confirmText = self.colorHex .. "Enter #FFFFFF- " .. self.confirm .. "\n" .. confirmText
	end
	dxDrawText(
		confirmText,
		0, screenSize.y * 0.51,
		screenSize.x, screenSize.y,
		tocolor(255, 255, 255, 255 * self.fadeProgress),
		1,
		Assets.fonts.moneyText,
		"center",
		"top",
		false, false, false, true
	)
end

function SellCarScreen:update(deltaTime)
	self.super:update(deltaTime)
end

function SellCarScreen:onKey(key)
	self.super:onKey(key)
	if key == "enter" then
		if not self.canSell then
			return
		end
		GarageCar.sell()
		if GarageCar.getCarsCount() > 1 then
			self.screenManager:showScreen(MainScreen(2))
		end
	elseif key == "backspace" then
		self.screenManager:showScreen(MainScreen(2))
	end
end
