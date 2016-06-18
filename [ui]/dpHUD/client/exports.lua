local states = {}

function setVisible(visible)
	if not visible then
		states.radar = Radar.visible
		states.speedometer = Speedometer.visible
		Radar.setVisible(false)
		Speedometer.setVisible(false)		
	else
		Radar.setVisible(states.radar)
		Speedometer.setVisible(states.speedometer)		
	end
end

function setRadarVisible(...)
	return Radar.setVisible(...)
end

function setSpeedometerVisible(...)
	return Speedometer.setVisible(...)
end