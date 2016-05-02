CarSelectScreen = {}
addEvent("dpGarage.loaded", false)

local function updateArrowsPosition()
	local vehicle = GarageCar.getVehicle()
	local left = Vector3(vehicle:getComponentPosition("wheel_rf_dummy")) * 1.2 + Vector3(0.2, 0.2, 0)
	local right = Vector3(vehicle:getComponentPosition("wheel_lb_dummy"))
	VehicleArrows.setPosition(
		vehicle.matrix:transformPosition(left) + Vector3(0, 0, 0.3), 
		vehicle.matrix:transformPosition(right) + Vector3(0, 0, 0.3)
	)	
end

local function arrowRight()
	GarageCar.showNextCar()
	updateArrowsPosition()
end

local function arrowLeft()
	GarageCar.showPreviousCar()
	updateArrowsPosition()
end

function CarSelectScreen.start()
	MainMenu.start()

	bindKey("arrow_r", "down", arrowRight)
	bindKey("arrow_l", "down", arrowLeft)
	addEventHandler("dpGarage.loaded", resourceRoot, updateArrowsPosition)
end

function CarSelectScreen.draw()
	MainMenu.draw()
	VehicleArrows.draw()
end

function CarSelectScreen.stop()
	MainMenu.stop()
	unbindKey("arrow_r", "down", arrowRight)
	unbindKey("arrow_l", "down", arrowLeft)

	removeEventHandler("dpGarage.loaded", resourceRoot, updateArrowsPosition)
end