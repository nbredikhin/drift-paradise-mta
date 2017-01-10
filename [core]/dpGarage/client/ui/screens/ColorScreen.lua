ColorScreen = Screen:subclass "ColorScreen"

local colorMenus = {
	["BodyColor"]    = {locale="garage_tuning_paint_body",    position = Vector3(2916, -3188.8, 2535.6),   angle = 10},
	["SmokeColor"]    = {locale="garage_tuning_smoke_color",  position = Vector3(2916, -3188.8, 2535.6),   angle = 10},
	["WheelsColorF"]  = {locale="garage_tuning_paint_wheels", position = Vector3(2913.8, -3184.3, 2535.4), angle = 15},
	["WheelsColorR"]  = {locale="garage_tuning_paint_wheels", position = Vector3(2912.3, -3184.3, 2535.3), angle = 15},
	["SpoilerColor"] = {locale="garage_tuning_paint_spoiler", position = Vector3(2915, -3188.3, 2535.8),   angle = 185}
}

function ColorScreen:init(componentName)
	self.super:init()
	self.componentName = componentName
	local menuInfo = colorMenus[componentName]
	self.colorMenu = ColorMenu(exports.dpLang:getString(menuInfo.locale), menuInfo.position, menuInfo.angle)
	local color = GarageCar.getVehicle():getData(componentName)
	if color then
		self.colorMenu:setColor(unpack(color))
	end

	-- Цена
	local priceInfo = {0, 1}
	self.colorMenu.price = priceInfo[1]
	self.requiredLevel = priceInfo[2]

	self.colorPreviewEnabled = true
	CameraManager.setState("selecting" .. componentName, false, 3)	

	self.copyToAllWheels = false

	if self.componentName == "SmokeColor" then
		local vehicle = GarageCar.getVehicle()
		local smokePosition = vehicle.matrix:transformPosition(0, -2, 0)
		local currentColor = vehicle:getData("SmokeColor")
		self.emitter = exports.dpParticles:createEmitter({
		x = smokePosition.x,
		y = smokePosition.y,
		z = smokePosition.z,

		density = 1,
		delay = 0.025,
		lifetime = {2, 3},
		fadeInAt = 0.1,

		forceY = 6,

		startSize = 1.5,
		endSize = 6.5,

		forceZ = 1.2,

		r = currentColor[1] or 255,
		g = currentColor[2] or 255,
		b = currentColor[3] or 255
	})
	end
end

function ColorScreen:hide()
	self.super:hide()
	self.colorMenu:destroy()
end

function ColorScreen:draw()
	self.super:draw()
	self.colorMenu:draw(self.fadeProgress)
end

function ColorScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.colorMenu:update(deltaTime)

	if getKeyState("arrow_r") then
		self.colorMenu:increase(deltaTime)
	elseif getKeyState("arrow_l") then
		self.colorMenu:decrease(deltaTime)
	end
	if self.colorPreviewEnabled then
		if self.componentName == "BodyColor" then
			CarTexture.previewBodyColor(self.colorMenu:getColor())
		else
			GarageCar.previewTuning(self.componentName, {self.colorMenu:getColor()})
			if self.copyToAllWheels then
				if self.componentName == "WheelsColorF" then
					GarageCar.previewTuning("WheelsColorR", {self.colorMenu:getColor()})
				elseif self.componentName == "WheelsColorR" then
					GarageCar.previewTuning("WheelsColorR", {self.colorMenu:getColor()})
				end
			end
		end
		--GarageCar.previewTuning(self.componentName, {self.colorMenu:getColor()})
	end
	if self.componentName == "SmokeColor" then
		local r, g, b = self.colorMenu:getColor()
		exports.dpParticles:setEmitterOption(self.emitter, "r", r)
		exports.dpParticles:setEmitterOption(self.emitter, "g", g)
		exports.dpParticles:setEmitterOption(self.emitter, "b", b)
	end
end

function ColorScreen:onKey(key)
	self.super:onKey(key)

	if key == "arrow_u" then
		self.colorMenu:selectPreviousBar()
	elseif key == "arrow_d" then
		self.colorMenu:selectNextBar()
	elseif key == "f" then
		if string.find(self.componentName, "WheelsColor") then
			self.copyToAllWheels = not self.copyToAllWheels
			GarageCar.resetTuning()
		end
	elseif key == "backspace" then
		if self.emitter then
			exports.dpParticles:destroyEmitter(self.emitter)
		end
		self.colorPreviewEnabled = false
		GarageCar.resetTuning()
		CarTexture.reset()
		self.screenManager:showScreen(ColorsScreen(self.componentName))
	elseif key == "enter" then
		self.colorPreviewEnabled = false
		local this = self
		Garage.buy(self.colorMenu.price, self.requiredLevel, function(success)
			if success then
				GarageCar.applyTuning(this.componentName, {this.colorMenu:getColor()})

				if this.copyToAllWheels then
					if this.componentName == "WheelsColorF" then
						GarageCar.applyTuning("WheelsColorR", {this.colorMenu:getColor()})
					elseif this.componentName == "WheelsColorR" then
						GarageCar.applyTuning("WheelsColorR", {this.colorMenu:getColor()})
					end
				end						
			end
			CarTexture.reset()
			if self.emitter then
				exports.dpParticles:destroyEmitter(self.emitter)
			end
			this.screenManager:showScreen(ColorsScreen(self.componentName))
		end)
	end
end