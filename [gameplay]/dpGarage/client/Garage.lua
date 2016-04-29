Garage = {}
local isActive = false

function Garage.start()
	if isActive then
		return false
	end
	isActive = true
	localPlayer.dimension = 0
	GarageCar.start()
	CameraManager.start()
	GarageUI.start()
	showCursor(true)
end

function Garage.stop()
	if not isActive then
		return false
	end
	isActive = false
	GarageUI.stop()
	CameraManager.stop()
	GarageCar.stop()
	showCursor(false)
end

function Garage.isActive()
	return isActive
end