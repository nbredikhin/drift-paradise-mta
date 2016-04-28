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
end

function Garage.stop()
	if not isActive then
		return false
	end
	isActive = false
	CameraManager.stop()
	GarageCar.stop()
end

function Garage.isActive()
	return isActive
end