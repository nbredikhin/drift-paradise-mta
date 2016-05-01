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
	showChat(false)
	exports.dpHUD:setVisible(false)
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
	showChat(true)
	exports.dpHUD:setVisible(true)
end

function Garage.isActive()
	return isActive
end