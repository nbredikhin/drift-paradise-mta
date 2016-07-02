Map = {}
local oldInterior = 0

function Map.start()
	oldInterior = localPlayer.interior
	if not oldInterior then
		oldInterior = 0
	end
	localPlayer.interior = 16
	MapWorld.start()
	MapCamera.start()
	MapControls.start()
	MapIcons.start()
	MapUI.start()
end

function Map.draw()
	MapIcons.draw()
	MapUI.draw()
end

function Map.update(dt)
	dt = dt / 1000
	MapWorld.update(dt)
	MapCamera.update(dt)
	MapControls.update(dt)
end

function Map.stop()
	localPlayer.interior = oldInterior
	MapWorld.stop()
	MapCamera.stop()
	MapControls.stop()
	MapIcons.stop()
	MapUI.stop()
end