Garage = {}
Garage.themePrimaryColor = {}
local isActive = false
local sound

function Garage.start(vehicles, enteredVehicleId)
	if isActive then
		return false
	end
	isActive = true

	Garage.themePrimaryColor = {exports.dpUI:getThemeColor()}
	localPlayer.dimension = 0
	exports.dpGameTime:forceTime(12, 0)
	Assets.start()

	showChat(false)

	exports.dpMainPanel:setVisible(false)
	exports.dpTabPanel:setVisible(false)
	exports.dpWorldMap:setVisible(false)	
	exports.dpHUD:setVisible(false)

	sound = playSound("assets/music/background_music.mp3"--[[, 2900, -3200.2, 2550]], true)
	if isElement(sound) then
		sound:setEffectEnabled("reverb", true)
		sound.volume = 0--0.08
		sound.maxDistance = 50
		sound.playbackPosition = math.random(0, sound.length)
	end

	setTimer(function () 
		GarageCar.start(vehicles)
		GarageCar.showCarById(enteredVehicleId)
		CameraManager.start()
		GarageUI.start()		
		setTimer(function () 
			triggerEvent("dpGarage.loaded", resourceRoot)
			CarTexture.start()
			fadeCamera(true)
		end, 500, 1)
	end, 500, 1)
end

-- Garage.start({{model=562}, {model=411}})

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
	exports.dpGameTime:restoreTime()
	showChat(true)
	exports.dpHUD:setVisible(true)
	if isElement(sound) then
		destroyElement(sound)
	end
end

function Garage.isActive()
	return isActive
end

function Garage.selectCarAndExit()
	exitGarage(GarageCar.getId())
end