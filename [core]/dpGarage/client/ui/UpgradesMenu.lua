UpgradesMenu = TuningMenu:subclass "UpgradesMenu"

local PARAM_CHANGE_SPEED = 1

function UpgradesMenu:init(position, rotation)
	self.super:init(position, rotation, Vector2(1.4, 1.17))
	self.headerHeight = 70
	self.headerText = exports.dpLang:getString("garage_tuning_config_upgrades")

	self.buttonHeight = 80
	self.buttonOffset = 20

	self.buttons = {
		{
			name 		= exports.dpLang:getString("garage_tuning_config_street_upgrade"), 
			description = exports.dpLang:getString("garage_tuning_config_street_description"), 
			price 		= 1000
		},
		{
			name 		= exports.dpLang:getString("garage_tuning_config_drift_upgrade"), 
			description = exports.dpLang:getString("garage_tuning_config_drift_description"), 
			price 		= 3000
		}
	}
	self.activeButton = 1
	self.price = 0
end

function UpgradesMenu:draw(fadeProgress)
	self.super:draw(fadeProgress)

	dxSetRenderTarget(self.renderTarget, true)
	dxDrawRectangle(0, 0, self.resolution.x, self.resolution.y, tocolor(42, 40, 41))
	dxDrawRectangle(0, 0, self.resolution.x, self.headerHeight, tocolor(32, 30, 31))
	dxDrawText(self.headerText, 20, 0, self.resolution.x, self.headerHeight, tocolor(255, 255, 255), 1, Assets.fonts.colorMenuHeader, "left", "center")
	
	local priceText = ""
	if self.price > 0 then
		priceText = "$" .. tostring(self.price)
	else
		priceText = exports.dpLang:getString("price_free")
	end
	dxDrawText(priceText, 0, 0, self.resolution.x - 20, self.headerHeight, tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3]), 1, Assets.fonts.colorMenuPrice, "right", "center")

	local y = self.headerHeight + self.buttonOffset
	local buttonWidth = self.resolution.x - self.buttonOffset * 2
	for i, button in ipairs(self.buttons) do
		local cursorSize = 5
		local r, g, b, a = 255, 255, 255, 255
		local isActiveButton = false
		if i == self.activeButton then
			isActiveButton = true
			cursorSize = 10
			r, g, b = Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3]
		else
			a = 200
		end		

		-- Подпись
		if isActiveButton then
			dxDrawRectangle(self.buttonOffset, y, buttonWidth, self.buttonHeight, tocolor(r, g, b, a))
		end
		dxDrawText(button.name, self.buttonOffset, y, self.resolution.x - self.buttonOffset, y + self.buttonHeight / 3, tocolor(255, 255, 255, a), 1, Assets.fonts.menuLabel, "center", "center", true, false)
		dxDrawText(button.description, self.buttonOffset, y + self.buttonHeight / 3, self.resolution.x - self.buttonOffset, y + self.buttonHeight, tocolor(255, 255, 255, a * 0.8), 1, Assets.fonts.tuningPanelText, "center", "top", false, true)

		y = y + self.buttonOffset + self.buttonHeight
	end

	dxSetRenderTarget()
end


function UpgradesMenu:update(deltaTime)
	self.super:update(deltaTime)
end

function UpgradesMenu:selectNext()
	self.activeButton = self.activeButton + 1
	if self.activeButton > #self.buttons then
		self.activeButton = 1
	end
	self.price = self.buttons[self.activeButton].price
end

function UpgradesMenu:selectPrevious()
	self.activeButton = self.activeButton - 1
	if self.activeButton < 1 then
		self.activeButton = #self.buttons
	end
	self.price = self.buttons[self.activeButton].price
end