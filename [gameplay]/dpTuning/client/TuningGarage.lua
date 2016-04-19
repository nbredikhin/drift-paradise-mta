TuningGarage = {}

function TuningGarage.start()
	localPlayer.alpha = 0
	localPlayer.vehicle.frozen = true
	toggleAllControls(false, true, false)
end

function TuningGarage.stop()
	localPlayer.alpha = 255
	localPlayer.vehicle.frozen = false
	toggleAllControls(true)
end