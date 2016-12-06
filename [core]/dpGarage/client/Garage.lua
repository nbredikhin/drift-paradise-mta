Garage = {}
Garage.themePrimaryColor = {}
local isActive = false
local pendingBuyCallback

function Garage.start(vehicles, enteredVehicleId, vehicle)
	if isActive then
		return false
	end
	isActive = true

	Garage.themePrimaryColor = {exports.dpUI:getThemeColor()}
	localPlayer.dimension = 0
	exports.dpTime:forceTime(12, 0)

	exports.dpChat:setVisible(false)
	exports.dpMainPanel:setVisible(false)
	exports.dpTabPanel:setVisible(false)
	exports.dpWorldMap:setVisible(false)
	exports.dpHUD:setVisible(false)

	Assets.start()
	GarageCar.start(vehicle, vehicles)
	GarageUI.start()

	setTimer(function ()
		GarageCar.showCarById(enteredVehicleId)
		CameraManager.start()
		fadeCamera(true, 0.5)
		CarTexture.start()
		MusicPlayer.start()
	end, 1000, 1)
end

function Garage.stop()
	if not isActive then
		return false
	end
	isActive = false
	GarageUI.stop()
	CameraManager.stop()
	CarTexture.stop()
	GarageCar.stop()
	Assets.stop()
	MusicPlayer.stop()
	exports.dpTime:restoreTime()
	exports.dpChat:setVisible(true)
	exports.dpHUD:showAll()
	toggleAllControls(true)
end

function Garage.isActive()
	return isActive
end

function Garage.selectCarAndExit()
	exitGarage(GarageCar.getId())
end

function Garage.playRandomMusic(reason)
	if reason ~= "finished" then
		return false
	end
	if isElement(sound) then
		destroyElement(sound)
	end
	sound = playSound(musicURLs[math.random(1, #musicURLs)], false)
	sound:setEffectEnabled("reverb", true)
	sound.volume = 0.08
	sound.maxDistance = 50
end

function Garage.buy(price, level, callback)
	if type(price) ~= "number" or type(level) ~= "number" or type(callback) ~= "function" then
		outputDebugString("Garage.buy: bad arguments")
		return false
	end
	if pendingBuyCallback then
		callback(false)
		exports.dpSounds:playSound("error.wav")
		return false
	end
	if level > localPlayer:getData("level") then
		outputDebugString("Error: Not enough level")
		exports.dpSounds:playSound("error.wav")
		callback(false)
		return
	end
	if localPlayer:getData("money") < price then
		outputDebugString("Error: Not enough money")
		exports.dpSounds:playSound("error.wav")
		callback(false)
		return
	end
	pendingBuyCallback = callback
	triggerServerEvent("dpGarage.buy", resourceRoot, price, level)
end

addEvent("dpGarage.buy", true)
addEventHandler("dpGarage.buy", resourceRoot, function (success)
	if type(pendingBuyCallback) ~= "function" then
		exports.dpSounds:playSound("error.wav")
		return false
	end
	if success then
		exports.dpSounds:playSound("sell.wav")
	end
	pendingBuyCallback(success)
	pendingBuyCallback = nil
end)
