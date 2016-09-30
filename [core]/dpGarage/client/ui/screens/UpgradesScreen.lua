UpgradesScreen = Screen:subclass "UpgradesScreen"

function UpgradesScreen:init(wheelsSide)
	self.disabled = false
	self.wheelsSide = wheelsSide
	self.menu = UpgradesMenu(
		Vector3(2915.5, -3184.3, 2535.3),
		0
	)

	CameraManager.setState("previewUpgrades", false, 3)
	--local price = unpack(exports.dpShared:getTuningPrices("wheels_advanced"))
	self.super:init()
end

function UpgradesScreen:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
end

function UpgradesScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.menu:update(deltaTime)
end

function UpgradesScreen:onKey(key)
	self.super:onKey(key)
	if self.disabled then
		return
	end

	if key == "enter" then
		-- local price, level = unpack(exports.dpShared:getTuningPrices("wheels_advanced"))
		-- local this = self
		-- self.disabled = true
		-- Garage.buy(price, level, function (success)
		-- 	if success then
		-- 		for i = 1, 3 do
		-- 			GarageCar.applyTuningFromData(this.dataNames[i])
		-- 		end
		-- 		GarageCar.resetTuning()
		-- 		this.screenManager:showScreen(ConfigurationsScreen(this.wheelsSide))					
		-- 	end
		-- end)
	elseif key == "backspace" then
		-- self.disabled = true
		-- GarageCar.resetTuning()
		-- self.screenManager:showScreen(ConfigurationsScreen(self.wheelsSide))
	elseif key == "arrow_u" then
		self.menu:selectPrevious()
	elseif key == "arrow_d" then
		self.menu:selectNext()
	end
end