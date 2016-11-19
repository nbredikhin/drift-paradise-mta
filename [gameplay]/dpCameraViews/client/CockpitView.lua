CockpitView = {}
local speedometerState = false
local isActive = false

-- Возможность смотреть назад
local LOOK_BACK_ENABLED = true
-- Скорость вращения камеры
local CAMERA_ROTATION_SPEED = 6
-- Угол поворота при просмотре на Q и E
local SIDE_LOOK_ANGLE = 60
local MIN_DRIFT_SPEED = 0.17

local positionOffset = Vector3()
local lookOffset =  Vector3()

local targetLookOffset = Vector3()
local currentLookOffset = Vector3()

local startCameraAngle = 0
local prevTurnVelocity = 0

-- Тряска
local SHAKE_AMOUNT = 0.012
local cameraShakeZ = 0
local cameraShakeX = 0
local cameraShakeMul = 0.9

-- Мышь
local mouseLookSpeed = 50
local mouseLookX = 0
local mouseLookY = 0
local mouseHorizontalLimit = 60
local mouseVerticalLimit = 40

-- Костыли
local skipFrame = false -- Пропуск первого кадра, чтобы не было видно рук

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

local function onCursorMove(x, y)
	if isCursorShowing() or isMTAWindowActive() then
		return
	end
	local mx = (x - 0.5) * mouseLookSpeed
	local my = (y - 0.5) * mouseLookSpeed

	mouseLookX = mouseLookX + mx
	mouseLookY = mouseLookY + my

	mouseLookX = math.max(-mouseHorizontalLimit, math.min(mouseHorizontalLimit, mouseLookX))
	mouseLookY = math.max(-mouseVerticalLimit, math.min(mouseVerticalLimit, mouseLookY))
end

local function update(deltaTime)	
	if skipFrame then
		skipFrame = false
		return
	end
	if not localPlayer.vehicle then
		CockpitView.stop()
		return 
	end
	if localPlayer:getData("activeUI") == "photoMode" then
		return
	end	
	deltaTime = deltaTime / 1000

	cameraShakeX = cameraShakeX * cameraShakeMul
	cameraShakeZ = cameraShakeZ * cameraShakeMul
	cameraShake = Vector3(cameraShakeX * (math.random() * 2 - 1), 0, cameraShakeZ * (math.random() * 2 - 1))

	local sideLookAngle = 0

	-- Управление мышью
	sideLookAngle = sideLookAngle + mouseLookX
	local mouseLookOffset = -mouseLookY / 90

	-- Обзор в стороны
	local lookLeftState = getControlState("vehicle_look_left")
	local lookRightState = getControlState("vehicle_look_right")
	if LOOK_BACK_ENABLED and lookLeftState and lookRightState then
		sideLookAngle = 180
		mouseLookX = 0 
		mouseLookY = 0
	elseif lookLeftState then 
		sideLookAngle = -SIDE_LOOK_ANGLE
		mouseLookX = 0
		mouseLookY = 0
	elseif lookRightState then
		sideLookAngle = SIDE_LOOK_ANGLE
		mouseLookX = 0
		mouseLookY = 0
	end
	-- Следование камеры за дрифтом
	local driftAngle = 0 
	if localPlayer.vehicle.onGround then
		local velocity = localPlayer.vehicle.velocity
		local speedSquared = velocity:getSquaredLength()
		local angleMul = math.min(1, speedSquared / MIN_DRIFT_SPEED)
		local velocityAngle = localPlayer.vehicle.rotation.z
		if speedSquared > 0.00001 then
			velocityAngle = math.deg(getVectorAngle(velocity)) + 270
		end
		local angleDifference = -differenceBetweenAngles(localPlayer.vehicle.rotation.z, velocityAngle)
		if math.abs(angleDifference) < 120 then
			driftAngle = angleDifference * angleMul
		end

		-- Тряска от скорости
		cameraShakeX = cameraShakeX + math.random() / 4000 * speedSquared
		cameraShakeZ = cameraShakeZ + math.random() / 6000 * speedSquared
	end

	-- Поворот камеры
	local currentCameraAngle = math.rad(startCameraAngle + driftAngle + sideLookAngle)
	targetLookOffset = Vector3(math.sin(currentCameraAngle), math.cos(currentCameraAngle), lookOffset.z + mouseLookOffset)
	currentLookOffset = currentLookOffset + (targetLookOffset - currentLookOffset) * deltaTime * CAMERA_ROTATION_SPEED
	currentLookOffset = currentLookOffset + cameraShake

	-- Положение камеры в машине
	local cameraPos = localPlayer.vehicle.matrix:transformPosition(positionOffset)
	local cameraLook = localPlayer.vehicle.matrix:transformPosition(positionOffset + currentLookOffset)
	local cameraRoll = -localPlayer.vehicle.rotation.y
	
	-- Обновление камеры
	Camera.setMatrix(cameraPos, cameraLook, cameraRoll - cameraShake.x * 50)
end

local function updateShake(collider, force)
	if force < 60 then
		return false
	end
	local mul = math.max(math.min(10, force / 60), 0) 
	cameraShakeX = cameraShakeX + SHAKE_AMOUNT * mul * 0.9
	cameraShakeZ = cameraShakeZ + SHAKE_AMOUNT * mul * 0.2
end

function CockpitView.start()
	if isActive then
		return false
	end
	isActive = true
	local offsets = cockpitOffsets[localPlayer.vehicle.model]
	if not offsets then
		return false
	end

	positionOffset = Vector3(offsets.bx, offsets.by, offsets.bz)
	lookOffset = (Vector3(offsets.ax, offsets.ay, offsets.az) - positionOffset):getNormalized()
	startCameraAngle = getVectorAngle(lookOffset)
	localPlayer.alpha = 0

	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientVehicleCollision", localPlayer.vehicle, updateShake)
	addEventHandler("onClientCursorMove", root, onCursorMove)
	localPlayer:setData("dpHUD.hideSpeedometer", true, false)
	skipFrame = true
	return true
end

function CockpitView.stop()
	if not isActive then
		return false
	end
	isActive = false
	localPlayer.alpha = 255
	Camera.setTarget(localPlayer)
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientCursorMove", root, onCursorMove)
	if isElement(localPlayer.vehicle) then
		removeEventHandler("onClientVehicleCollision", localPlayer.vehicle, updateShake)
	end

	localPlayer:setData("dpHUD.hideSpeedometer", false, false)
end