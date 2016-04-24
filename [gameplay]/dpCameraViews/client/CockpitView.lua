CockpitView = {}
local isActive = false

-- Возможность смотреть назад
local LOOK_BACK_ENABLED = false
-- Скорость вращения камеры
local CAMERA_ROTATION_SPEED = 5
-- Угол поворота при просмотре на Q и E
local SIDE_LOOK_ANGLE = 60
local MIN_DRIFT_SPEED = 0.17

local positionOffset = Vector3()
local lookOffset =  Vector3()
local previousPosition = Vector3()
local targetLookOffset = Vector3()
local currentLookOffset = Vector3()
local startCameraAngle = 0

local function differenceBetweenAngles(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	while difference < -180 do
		difference = difference + 360
	end
	while difference > 180 do
		difference = difference - 360
	end
	return difference
end

local function wrapAngle(value)
	if not value then
		return 0
	end
	value = math.mod(value, 360)
	if value < 0 then
		value = value + 360
	end
	return value
end

local function getVectorAngle(vector)
	return math.atan2(vector.y, vector.x)
end

local function update(deltaTime)
	if not localPlayer.vehicle then
		CockpitView.stop()
		return 
	end
	deltaTime = deltaTime / 1000

	local sideLookAngle = 0
	if LOOK_BACK_ENABLED and getKeyState("q") and getKeyState("e") then
		sideLookAngle = 180
	elseif getKeyState("q") then 
		sideLookAngle = -SIDE_LOOK_ANGLE
	elseif getKeyState("e") then
		sideLookAngle = SIDE_LOOK_ANGLE
	end
	-- Следование камеры за дрифтом
	local velocity = localPlayer.vehicle.velocity
	local speedSquared = velocity:getSquaredLength()
	local angleMul = math.min(1, speedSquared / MIN_DRIFT_SPEED)
	local velocityAngle = localPlayer.vehicle.rotation.z
	if speedSquared > 0.00001 then
		velocityAngle = math.deg(getVectorAngle(velocity)) + 270
	end
	local driftAngle = -differenceBetweenAngles(localPlayer.vehicle.rotation.z, velocityAngle) * angleMul

	-- Поворот камеры
	local currentCameraAngle = math.rad(startCameraAngle + driftAngle + sideLookAngle)
	targetLookOffset = Vector3(math.sin(currentCameraAngle), math.cos(currentCameraAngle), lookOffset.z)
	currentLookOffset = currentLookOffset + (targetLookOffset - currentLookOffset) * deltaTime * CAMERA_ROTATION_SPEED

	-- Положение камеры в машине
	local cameraPos = localPlayer.vehicle.matrix:transformPosition(positionOffset)
	local cameraLook = localPlayer.vehicle.matrix:transformPosition(positionOffset + currentLookOffset)
	local cameraRoll = -localPlayer.vehicle.rotation.y
	
	-- Обновление камеры
	Camera.setMatrix(cameraPos, cameraLook, cameraRoll)
end

function CockpitView.start()
	local offsets = cockpitOffsets[localPlayer.vehicle.model]
	if not offsets then
		return false
	end

	positionOffset = Vector3(offsets.bx, offsets.by, offsets.bz)
	lookOffset = (Vector3(offsets.ax, offsets.ay, offsets.az) - positionOffset):getNormalized()
	startCameraAngle = getVectorAngle(lookOffset)
	outputChatBox("CURRENT POS: " .. tostring(positionOffset))
	outputChatBox("CURRENT LOOK: " .. tostring(Vector3(offsets.ax, offsets.ay, offsets.az)))
	outputChatBox("CURRENT ANGLE: " .. tostring(startCameraAngle / math.pi * 180))
	localPlayer.alpha = 0

	addEventHandler("onClientPreRender", root, update)
	return true
end

function CockpitView.stop()
	localPlayer.alpha = 255
	Camera.setTarget(localPlayer)
	removeEventHandler("onClientPreRender", root, update)
end

CockpitView.start()