Garage = {}
Garage.themePrimaryColor = {}
local isActive = false

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
	exports.dpHUD:setVisible(false)

	setTimer(function () 
		GarageCar.start(vehicles)
		GarageCar.showCarById(enteredVehicleId)
		CameraManager.start()
		GarageUI.start()		
		setTimer(function () 
			triggerEvent("dpGarage.loaded", resourceRoot)
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
	GarageCar.stop()
	Assets.stop()
	exports.dpGameTime:restoreTime()
	showChat(true)
	exports.dpHUD:setVisible(true)
end

function Garage.isActive()
	return isActive
end

function Garage.selectCarAndExit()
	exitGarage(GarageCar.getId())
end