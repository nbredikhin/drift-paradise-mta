MapCamera = {}
local CAMERA_MIN_HEIGHT = 5
local CAMERA_MAX_HEIGHT = 20
local CAMERA_DISTANCE_HEIGHT = 8
local CAMERA_MAX_OFFSET = 3

local cameraPosition
local cameraHeight
local CAMERA_VERTICAL_SPEED = 8
local CAMERA_HORIZONTAL_SPEED = 8
local targetCameraHeight
local targetCameraPosition

function MapCamera.start()
	cameraPosition = Vector2(MapWorld.getMapFromWorldPosition(localPlayer.position))
	cameraHeight = CAMERA_MIN_HEIGHT

	targetCameraHeight = cameraHeight
	targetCameraPosition = cameraPosition
end

function MapCamera.stop()

end

function MapCamera.update(dt)
	local cameraDistance = 0
	if cameraHeight < CAMERA_DISTANCE_HEIGHT + CAMERA_MIN_HEIGHT then
		cameraDistance = (cameraHeight - CAMERA_DISTANCE_HEIGHT - CAMERA_MIN_HEIGHT) / (CAMERA_DISTANCE_HEIGHT - CAMERA_MIN_HEIGHT) * 2
	end
	local offset = Vector3(0, cameraDistance, cameraHeight)
	local position = Vector3(cameraPosition.x, cameraPosition.y, 0)
	setCameraMatrix(position + offset + MapWorld.position, position + MapWorld.position)

	cameraHeight = cameraHeight + (targetCameraHeight - cameraHeight) * dt * CAMERA_VERTICAL_SPEED
	cameraPosition = cameraPosition + (targetCameraPosition - cameraPosition) * dt * CAMERA_HORIZONTAL_SPEED

	targetCameraHeight = math.min(CAMERA_MAX_HEIGHT, math.max(targetCameraHeight, CAMERA_MIN_HEIGHT))
end

function MapCamera.setHeight(height)
	targetCameraHeight = height
end

function MapCamera.setPosition(position)
	targetCameraPosition = position
end

function MapCamera.movePosition(position)
	targetCameraPosition = targetCameraPosition + position
end

function MapCamera.moveHeight(height)
	targetCameraHeight = targetCameraHeight + height
end

function MapCamera.getHeight()
	return cameraHeight
end