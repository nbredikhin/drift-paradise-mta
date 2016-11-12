UpgradesMenu = TuningMenu:subclass "UpgradesMenu"

local PARAM_CHANGE_SPEED = 1

function UpgradesMenu:init(position, rotation)
	self.super:init(position, rotation, Vector2(1.4, 1.17))
	self.headerHeight = 70
	self.headerText = exports.dpLang:getString("garage_tuning_config_upgrades")

	self.buttonHeight = 80
	self.buttonOffset = 20

	self.buttons = {}

	local streetUpgradePrice = exports.dpShared:getTuningPrices("upgrade_price_street")
	local driftUpgradePrice = exports.dpShared:getTuningPrices("upgrade_price_drift")
	
	table.insert(self.buttons, {
		upgrade 	= "StreetHandling",
		name 		= exports.dpLang:getString("garage_tuning_config_street_upgrade"), 
		description = exports.dpLang:getString("garage_tuning_config_street_description"), 
		price 		= streetUpgradePrice,
		enabled 	= exports.dpVehicles:hasVehicleHandling(GarageCar.getName(), "street", 2)
	})

	if exports.dpVehicles:hasVehicleHandling(GarageCar.getName(), "drift") then
		table.insert(self.buttons, {
			upgrade 	= "DriftHandling",
			name 		= exports.dpLang:getString("garage_tuning_config_drift_upgrade"), 
			description = exports.dpLang:getString("garage_tuning_config_drift_description"), 
			price 		= driftUpgradePrice,
			enabled 	= exports.dpVehicles:hasVehicleHandling(GarageCar.getName(), "drift")
		})
	end
	self.activeButton = 1
	self.price = false

	self:updateSelection()
end

function UpgradesMenu:hasUpgrade(name)
	if not name then
		name = self.buttons[self.activeButton].upgrade
	end
	return GarageCar.getVehicle():getData(name) > 0
end

function UpgradesMenu:getSelectedUpgrade()
	local price = self.buttons[self.activeButton].price
	local money = localPlayer:getData("money")
	if not self.buttons[self.activeButton].enabled or self:hasUpgrade() or money < price then
		return false
	end
	return self.buttons[self.activeButton].upgrade, price
end

function UpgradesMenu:draw(fadeProgress)
	self.super:draw(fadeProgress)

	dxSetRenderTarget(self.renderTarget, true)
	dxDrawRectangle(0, 0, self.resolution.x, self.resolution.y, tocolor(42, 40, 41))
	dxDrawRectangle(0, 0, self.resolution.x, self.headerHeight, tocolor(32, 30, 31))
	dxDrawText(self.headerText, 20, 0, self.resolution.x, self.headerHeight, tocolor(255, 255, 255), 1, Assets.fonts.colorMenuHeader, "left", "center")
	
	local priceText = ""
	if self.price then
		if self.price > 0 then
			priceText = "$" .. tostring(self.price)
		else
			priceText = exports.dpLang:getString("price_free")
		end
	end
	dxDrawText(priceText, 0, 0, self.resolution.x - 20, self.headerHeight, tocolor(Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3]), 1, Assets.fonts.colorMenuPrice, "right", "center")

	local y = self.headerHeight + self.buttonOffset
	local buttonWidth = self.resolution.x - self.buttonOffset * 2
	local money = localPlayer:getData("money")
	for i, button in ipairs(self.buttons) do
		local cursorSize = 5
		local r, g, b, a = 255, 255, 255, 255
		local isActiveButton = false
		local isDisabledButton = false
		if i == self.activeButton then
			isActiveButton = true
			cursorSize = 10
			r, g, b = Garage.themePrimaryColor[1], Garage.themePrimaryColor[2], Garage.themePrimaryColor[3]
		else
			a = 200
		end

		if not button.enabled or self:hasUpgrade(button.upgrade) or money < button.price then
			r, g, b = 50, 50, 50
			isDisabledButton = true
		end
		-- Подпись
		if isActiveButton then
			dxDrawRectangle(self.buttonOffset - 10, y - 10, buttonWidth + 20, self.buttonHeight + 20, tocolor(r, g, b, a))
		end
		local textColor = tocolor(255, 255, 255, a)
		if isDisabledButton then
			textColor = tocolor(100, 100, 100, a)
		end
		dxDrawText(button.name, self.buttonOffset, y, self.resolution.x - self.buttonOffset, y + self.buttonHeight / 3, textColor, 1, Assets.fonts.menuLabel, "left", "center", true, false)
		dxDrawText(button.description, self.buttonOffset, y + self.buttonHeight / 3, self.resolution.x - self.buttonOffset, y + self.buttonHeight, textColor, 1, Assets.fonts.tuningPanelText, "left", "top", false, true)
		y = y + self.buttonOffset + self.buttonHeight
	end

	dxSetRenderTarget()
end


function UpgradesMenu:update(deltaTime)
	self.super:update(deltaTime)
end

function UpgradesMenu:updateSelection()
	self.price = self.buttons[self.activeButton].price
	if self:hasUpgrade(self.buttons[self.activeButton].upgrade) then
		self.price = false
	end
end

function UpgradesMenu:selectNext()
	self.activeButton = self.activeButton + 1
	if self.activeButton > #self.buttons then
		self.activeButton = 1
	end
	self:updateSelection()
end

function UpgradesMenu:selectPrevious()
	self.activeButton = self.activeButton - 1
	if self.activeButton < 1 then
		self.activeButton = #self.buttons
	end
	self:updateSelection()
end