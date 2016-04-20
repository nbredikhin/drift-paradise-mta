TuningGarage = {}

function TuningGarage.start()
	localPlayer.alpha = 0
	localPlayer.vehicle.frozen = true
	toggleAllControls(false, true, false)
end

function TuningGarage.stop()
	localPlayer.alpha = 255
	if localPlayer.vehicle then
		localPlayer.vehicle.frozen = false
	end
	toggleAllControls(true)
end