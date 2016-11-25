DriftView = {}
local isActive = false

local cameraHeight = 1.4
local cameraOffset = Vector3(0, -6.5, 0)
local lookAtOffset = Vector3(0, 3, 0)

local targetRotation = 0
local currentRotation = 0
local rotationMul = 0.05

local currentCameraPosition = Vector3(cameraOffset) + Vector3(0, 0, cameraHeight)
local currentLookOffset = Vector3(lookAtOffset)
local currentCameraRoll = 0
local currentCameraFOV = 70
local currentCameraZ = 0
local currentCameraRotation = math.pi

local function getDriftAngle()
	local vehicle = localPlayer.vehicle
	if vehicle.velocity.length < 0.2 then
		return 0, false
	end

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.atan2(det, dot)
	return angle
end

function differenceBetweenAngles(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	while difference < -180 do
		difference = difference + 360
	end
	while difference > 180 do
		difference = difference - 360
	end
	return difference
end

local _getKeyState = getKeyState
local function getKeyState(...)
	return _getKeyState(...) and not isMTAWindowActive()
end

local function update(deltaTime)
	if localPlayer:getData("activeUI") == "photoMode" then
		return
	end	
	deltaTime = deltaTime / 1000

	local vehicle = localPlayer.vehicle
	if not vehicle then
		return
	end

	local driftAngle = -getDriftAngle()
	local targetCameraRotation = driftAngle + math.pi
	currentCameraRotation = currentCameraRotation + (targetCameraRotation - currentCameraRotation) * deltaTime * 5

	local len = #cameraOffset
	local targetCameraPosition = Vector3(math.sin(currentCameraRotation) * len, math.cos(currentCameraRotation) * len, cameraHeight)
	local targetLookOffset = lookAtOffset + Vector3(driftAngle * 3.1, 0, 0)

	local targetCameraRoll = driftAngle * 5
	currentCameraRoll = currentCameraRoll + (targetCameraRoll - currentCameraRoll) * deltaTime * 2

	local targetCameraFOV = 70 + math.abs(driftAngle) * 20
	currentCameraFOV = currentCameraFOV + (targetCameraFOV - currentCameraFOV) * deltaTime * 3	


	local disableHotkeys = localPlayer:getData("activeUI") and localPlayer:getData("activeUI") ~= "raceUI"
	local bothDown = false
	if math.abs(driftAngle) > math.pi * 0.6 and #vehicle.velocity > 0.2 then
		local lookRotation = 0
		targetCameraPosition = Vector3(math.sin(lookRotation) * len, math.cos(lookRotation) * len, cameraHeight)
		targetLookOffset = Vector3(0, 1, 0)	
		currentCameraFOV = 70
		currentCameraRoll = 0
	else
		if getKeyState("e") and getKeyState("q") and not disableHotkeys then
			bothDown = true
			local lookRotation = 0
			targetCameraPosition = Vector3(math.sin(lookRotation) * len, math.cos(lookRotation) * len, cameraHeight)
			targetLookOffset = Vector3(0, 1, 0)	
			currentCameraFOV = 70
			currentCameraRoll = 0
		end				
	end

	if not bothDown and not disableHotkeys then
		if getKeyState("e") then
			local lookRotation = -math.pi / 2
			targetCameraPosition = Vector3(math.sin(lookRotation) * len, math.cos(lookRotation) * len, cameraHeight)
			targetLookOffset = Vector3()
			currentCameraFOV = 70
			currentCameraRoll = 0					
		elseif getKeyState("q") then
			local lookRotation = math.pi / 2
			targetCameraPosition = Vector3(math.sin(lookRotation) * len, math.cos(lookRotation) * len, cameraHeight)
			targetLookOffset = Vector3()
			currentCameraFOV = 70
			currentCameraRoll = 0					
		end	
	end

	currentCameraPosition = currentCameraPosition + (targetCameraPosition - currentCameraPosition) * deltaTime * 5
	currentLookOffset = currentLookOffset + (targetLookOffset - currentLookOffset) * deltaTime * 4

	setCameraMatrix(
		vehicle.matrix:transformPosition(currentCameraPosition), 
		vehicle.matrix:transformPosition(currentLookOffset), 
		currentCameraRoll, 
		currentCameraFOV
	)
end

function DriftView.start()
	if isActive then
		return false
	end
	isActive = true
	currentCameraZ = localPlayer.vehicle.position.z
	addEventHandler("onClientPreRender", root, update)
end

function DriftView.stop()
	if not isActive then
		return false
	end
	isActive = false	
	removeEventHandler("onClientPreRender", root, update)
end