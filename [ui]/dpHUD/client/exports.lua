local states = {}

function showAll()
	Radar.setVisible(true)
	Speedometer.setVisible(true)
	states.radar = true
	states.speedometer = true
end

function setVisible(visible)
	if not visible then
		--states.radar = Radar.visible
		--states.speedometer = Speedometer.visible
		Radar.setVisible(false)
		Speedometer.setVisible(false)		
	else
		Radar.setVisible(true)
		Speedometer.setVisible(true)		
	end
end

function setRadarVisible(...)
	return Radar.setVisible(...)
end

function setSpeedometerVisible(...)
	return Speedometer.setVisible(...)
end