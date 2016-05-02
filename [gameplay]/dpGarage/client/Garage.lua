Garage = {}
local isActive = false

function Garage.start(vehicles)
	if isActive then
		return false
	end
	isActive = true
	localPlayer.dimension = 0
	Assets.start()
	GarageCar.start(vehicles)
	CameraManager.start()
	GarageUI.start()
	showCursor(true)
	showChat(false)
	exports.dpHUD:setVisible(false)

	setTimer(function () 
		triggerEvent("dpGarage.loaded", resourceRoot)
	end, 500, 1)
end

function Garage.stop()
	if not isActive then
		return false
	end
	isActive = false
	GarageUI.stop()
	CameraManager.stop()
	GarageCar.stop()
	Assets.stop()
	showCursor(false)
	showChat(true)
	exports.dpHUD:setVisible(true)
end

function Garage.isActive()
	return isActive
end

function Garage.selectCarAndExit()
	exitGarage(GarageCar.getId())
end