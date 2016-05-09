Map = {}

function Map.start()
	localPlayer.interior = 1
	MapWorld.start()
	MapCamera.start()
	MapControls.start()
end

function Map.draw()

end

function Map.update(dt)
	dt = dt / 1000
	MapWorld.update(dt)
	MapCamera.update(dt)
	MapControls.update(dt)
end

function Map.stop()
	localPlayer.interior = 0
	MapWorld.stop()
	MapCamera.stop()
	MapControls.stop()
end