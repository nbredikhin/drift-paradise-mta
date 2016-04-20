GarageVehicle = {}

function GarageVehicle.start()
	toggleAllControls(false, true, false)
end

function GarageVehicle.stop()
	toggleAllControls(true)
end