WheelsScreen = Screen:subclass "WheelsScreen"

local menuInfos = {}
menuInfos["FrontWheels"] = {position = Vector3(2914, -3184.3, 2535.3), angle = 15, header="garage_tuning_config_front_wheels"}
menuInfos["RearWheels"] = {position = Vector3(2912.3, -3184.3, 2535.3), angle = 15, header="garage_tuning_config_rear_wheels"}

function WheelsScreen:init(wheelsSide)
	self.disabled = false
	self.wheelsSide = wheelsSide
	local menuInfo = menuInfos[wheelsSide]
	self.menu = WheelsMenu(
		exports.dpLang:getString(menuInfo.header),
		menuInfo.position,
		menuInfo.angle
	)

	-- Камера
	if wheelsSide == "RearWheels" then
		CameraManager.setState("previewWheelsR", false, 3)
	else
		CameraManager.setState("previewWheelsF", false, 3)
	end

	-- Дата
	self.dataNames = {
		"WheelsOffset",
		"WheelsAngle",
		"WheelsWidth"
	}
	local price = unpack(exports.dpShared:getTuningPrices("wheels_advanced"))
	self.menu.price = price
	local c = "R"
	if wheelsSide == "FrontWheels" then
		c = "F"
	end
	for i, name in ipairs(self.dataNames) do
		self.dataNames[i] = name .. c
	end

	local vehicle = GarageCar.getVehicle()
	self.menu.bars[1].value = vehicle:getData(self.dataNames[1])
	self.menu.bars[2].value = vehicle:getData(self.dataNames[2])
	self.menu.bars[3].value = vehicle:getData(self.dataNames[3])

	self.super:init()

	local this = self
	setTimer(function ()
		--this:updatePreview()
	end, 50, 0)
end

function WheelsScreen:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
	--self:updatePreview()
end

function WheelsScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.menu:update(deltaTime)

	if self.disabled or isMTAWindowActive() then
		return
	end
	if getKeyState("arrow_r") then
		self.menu:increase(deltaTime)
		self:updatePreview()
	elseif getKeyState("arrow_l") then
		self.menu:decrease(deltaTime)
		self:updatePreview()
	end
end

function WheelsScreen:updatePreview()
	if self.disabled then
		return
	end
	local bar, value = self.menu:getBarValue()
	local dataName = self.dataNames[bar]
	if string.find(dataName, "WheelsOffset") then
		value = value
	elseif string.find(dataName, "WheelsAngle") then
		value = value
	elseif string.find(dataName, "WheelsWidth") then
		value = value
	end
	GarageCar.previewTuning(dataName, value)
end

function WheelsScreen:onKey(key)
	self.super:onKey(key)
	if self.disabled then
		return
	end

	if key == "enter" then
		local price, level = unpack(exports.dpShared:getTuningPrices("wheels_advanced"))
		local this = self
		self.disabled = true
		Garage.buy(price, level, function (success)
			if success then
				for i = 1, 3 do
					GarageCar.applyTuningFromData(this.dataNames[i])
				end
				GarageCar.resetTuning()
				this.screenManager:showScreen(ConfigurationsScreen(this.wheelsSide))					
			end
		end)
	elseif key == "backspace" then
		self.disabled = true
		GarageCar.resetTuning()
		self.screenManager:showScreen(ConfigurationsScreen(self.wheelsSide))
	elseif key == "arrow_u" then
		self.menu:selectPreviousBar()
	elseif key == "arrow_d" then
		self.menu:selectNextBar()
	end
end