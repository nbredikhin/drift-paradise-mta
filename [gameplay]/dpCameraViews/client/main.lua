local cameraViews = {
	false, -- Обычная камера
	DriftView,
	CockpitView
}
local currentCameraViewIndex = 1
local currentCameraView

local function startCameraView(cameraView)
	if localPlayer.vehicle.controller ~= localPlayer then
		return false
	end
	if currentCameraView then
		currentCameraView.stop()
	end
	if cameraView then
		cameraView.start()
		currentCameraView = cameraView
	else
		if localPlayer.vehicle then
			setCameraViewMode(2)
		end
		setCameraTarget(localPlayer)
		setCameraMatrix(0, 0, 0)
		setCameraTarget(localPlayer)
		currentCameraView = nil
	end
	return true
end

bindKey("change_camera","down", function ()
	if not localPlayer.vehicle then
		startCameraView()
		return
	end
	currentCameraViewIndex = currentCameraViewIndex + 1
	if currentCameraViewIndex > #cameraViews then
		currentCameraViewIndex = 1
	end
	startCameraView(cameraViews[currentCameraViewIndex])
end)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function ()
	startCameraView(cameraViews[currentCameraViewIndex])
end)

addEventHandler("onClientVehicleStartExit", root, function (player)
	if player ~= localPlayer then
		return
	end
	startCameraView()
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	if localPlayer.vehicle then
		startCameraView(cameraViews[1])
	end
end)