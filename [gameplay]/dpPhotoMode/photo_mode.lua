PHOTO_MODE_KEY = "o"
CAMERA_MOVE_SPEED = 0.01
CAMERA_ROLL_SPEED = 0.02
CAMERA_ZOOM_SPEED = 5
MAX_CAMERA_FOV = 100
MIN_CAMERA_FOV = 30
MOUSE_SENSITIVITY = 0.2
MAX_DISTANCE_FROM_PLAYER = 80
SPEED_SLOWER_MUL = 0.1
SPEED_FASTER_MUL = 2.5
SMOOTH_MOVEMENT_SPEED = 0.004
SMOOTH_LOOK_SPEED = 0.002

-- Free look controls
CONTROLS = {
	ROLL_RIGHT = "e",
	ROLL_LEFT = "q",
	ROLL_CENTER = "r",
	MOVE_FORWARD = "w",
	MOVE_BACKWARD = "s",
	STRAFE_RIGHT = "d",
	STRAFE_LEFT = "a",
	ZOOM_OUT = "mouse_wheel_down" ,
	ZOOM_IN = "mouse_wheel_up",
	SPEED_SLOWER = "lalt",
	SPEED_FASTER = "lshift",
	MOVE_UP = "space",
	MOVE_DOWN = "lctrl",
	TOGGLE_SMOOTH = "c",
	NEXT_WEATHER = "z",
	PREVIOUS_WEATHER = "x",
	NEXT_TIME = "v",
	PREVIOUS_TIME = "b"
}

controlList = {"vehicle_left", "vehicle_right", "handbrake"}

weatherList = {
	{id = 0, name = "weather_extrasunny_la"},
	{id = 2, name = "weather_extrasunny_smog_la"},
	{id = 6, name = "weather_extrasunny_sf"},
	{id = 11, name = "weather_extrasunny_vegas"},
	{id = 13, name = "weather_extrasunny_countryside"},
	{id = 17, name = "weather_extrasunny_desert"},
	{id = 1, name = "weather_sunny_la"},
	{id = 3, name = "weather_sunny_smog_la"},
	{id = 5, name = "weather_sunny_sf"},
	{id = 10, name = "weather_sunny_vegas"},
	{id = 14, name = "weather_sunny_countryside"},
	{id = 18, name = "weather_sunny_desert"},
	{id = 4, name = "weather_cloudy_la1"},
	{id = 7, name = "weather_cloudy_sf2"},
	{id = 12, name = "weather_cloudy_vegas3"},
	{id = 15, name = "weather_cloudy_countryside4"},
	{id = 8, name = "weather_rainy_sf"},
	{id = 9, name = "weather_foggy_sf"},
	{id = 19, name = "weather_sandstorm_desert"},
}

-- Freecam position
local cameraPosition
local cameraPositionActual
-- Freecam direction
local cameraDirection
-- Freecam speed
local cameraSpeed
local cameraFOV
local cameraFOVActual
local cameraRoll
local cameraRollActual

-- Polar angle
local rotationX = 0
local actualRotationX = 0
-- Azimuthal angle
local rotationY = 0
local actualRotationY = 0
-- Smooth movement
local isSmoothMovementEnabled = false

local photoModeEnabled = false

-- Delays for smoothness
local mouseFrameDelay = 0
local updateFramesDelay = 0

timeHour, timeMinute = 0, 0
local savedWeather
currentWeather = 0

local function adjustFOV(wheelDir)
	cameraFOV = cameraFOV + wheelDir

	if cameraFOV > MAX_CAMERA_FOV then
		cameraFOV = MAX_CAMERA_FOV
	elseif cameraFOV < MIN_CAMERA_FOV then
		cameraFOV = MIN_CAMERA_FOV
	end
end

local function changeTime(isNext)
	setMinuteDuration(86400*1000)
	local hour, minute = getTime()
	timeMinute = minute + (isNext and 1 or -1)
	if timeMinute > 59 then
		timeMinute = 0
		timeHour = hour + 1
	elseif timeMinute < 0 then
		timeMinute = 59
		timeHour = hour - 1
	end
	if timeHour < 0 then
		timeHour = 23
	elseif timeHour > 23 then
		timeHour = 0
	end

	setTime(timeHour, timeMinute)
end

local function changeWeather(isNext)
	currentWeather = currentWeather + (isNext and 1 or -1)
	if currentWeather < 1 then
		currentWeather = #weatherList
	elseif currentWeather > #weatherList then
		currentWeather = 1
	end

	setWeather(weatherList[currentWeather].id)
end

local function enableSmoothMovement()
	rotationX = 0
end

local function disableSmoothMovement()
	cameraPosition = cameraPositionActual
	rotationX = actualRotationX
	rotationY = actualRotationY
	cameraRoll = cameraRollActual
	cameraFOV = cameraFOVActual
end

local function update(dt)
	if not photoModeEnabled then
		return
	end

	-- If game is actually inactive (working with GUI or so)
	-- Wait for 10 frames after game becomes active, just for smooth
	if isMTAWindowActive() or isCursorShowing() then
		updateFramesDelay = 10
		return
	elseif updateFramesDelay > 0 then
		updateFramesDelay = updateFramesDelay - 1
		return
	end

	-- Change time
	if getKeyState(CONTROLS.NEXT_TIME) then
		changeTime(true)
	elseif getKeyState(CONTROLS.PREVIOUS_TIME) then
		changeTime(false)
	end

	-- Adjust camera roll
	if getKeyState(CONTROLS.ROLL_RIGHT) then
		cameraRoll = cameraRoll + CAMERA_ROLL_SPEED * dt
	elseif getKeyState(CONTROLS.ROLL_LEFT) then
		cameraRoll = cameraRoll - CAMERA_ROLL_SPEED * dt
	end

	local cameraForward = Camera.matrix.forward
	local cameraRight = Vector3(cameraForward.y, -cameraForward.x, 0):getNormalized()
	cameraSpeed = Vector3(0, 0, 0)

	-- Move camera
	if getKeyState(CONTROLS.MOVE_FORWARD) then
		cameraSpeed = cameraSpeed + cameraForward
	elseif getKeyState(CONTROLS.MOVE_BACKWARD) then
		cameraSpeed = cameraSpeed - cameraForward
	end

	if getKeyState(CONTROLS.STRAFE_RIGHT) then
		cameraSpeed = cameraSpeed + cameraRight
	elseif getKeyState(CONTROLS.STRAFE_LEFT) then
		cameraSpeed = cameraSpeed - cameraRight
	end

	if getKeyState(CONTROLS.MOVE_UP) then
		cameraSpeed = cameraSpeed + Vector3(0, 0, 0.1)
	elseif getKeyState(CONTROLS.MOVE_DOWN) then
		cameraSpeed = cameraSpeed - Vector3(0, 0, 0.1)
	end

	cameraSpeed = CAMERA_MOVE_SPEED * cameraSpeed:getNormalized()
	if getKeyState(CONTROLS.SPEED_SLOWER) then
		cameraSpeed = cameraSpeed * SPEED_SLOWER_MUL
	elseif getKeyState(CONTROLS.SPEED_FASTER) then
		cameraSpeed = cameraSpeed * SPEED_FASTER_MUL
	end
	cameraPosition = cameraPosition + dt * cameraSpeed

	local distance = cameraPosition - localPlayer.position
	if (distance.length) > MAX_DISTANCE_FROM_PLAYER then
		cameraPosition = localPlayer.position +
		 distance:getNormalized() * MAX_DISTANCE_FROM_PLAYER
	end

	if isSmoothMovementEnabled then
		rotationX = rotationX * 0.97
		cameraPositionActual = cameraPositionActual + (cameraPosition - cameraPositionActual) * dt * SMOOTH_MOVEMENT_SPEED
		actualRotationX = actualRotationX + rotationX * dt * SMOOTH_LOOK_SPEED
		actualRotationY = actualRotationY + exports.dpUtils:differenceBetweenAnglesRadians(actualRotationY, rotationY) * dt * SMOOTH_LOOK_SPEED
		cameraRollActual = cameraRollActual + (cameraRoll - cameraRollActual) * dt * SMOOTH_MOVEMENT_SPEED
		cameraFOVActual = cameraFOVActual + (cameraFOV - cameraFOVActual) * dt * SMOOTH_MOVEMENT_SPEED
	else
		cameraPositionActual = cameraPosition
		actualRotationX = rotationX
		actualRotationY = rotationY
		cameraRollActual = cameraRoll
		cameraFOVActual = cameraFOV
	end
	cameraDirection.x = cameraPosition.x + dt * 100 * math.cos(actualRotationY) * math.sin(actualRotationX)
	cameraDirection.y = cameraPosition.y + dt * 100 * math.cos(actualRotationY) * math.cos(actualRotationX)
	cameraDirection.z = cameraPosition.z + dt * 100 * math.sin(actualRotationY)

	setCameraMatrix(cameraPositionActual, cameraDirection, cameraRollActual, cameraFOVActual)
end

local function onCursorMove(cX, cY, aX, aY)
	-- Same as in the update
	if isMTAWindowActive() or isCursorShowing() then
		mouseFrameDelay = 10
		return
	elseif mouseFrameDelay > 0 then
		mouseFrameDelay = mouseFrameDelay - 1
		return
	end

	local width, height = guiGetScreenSize()

	-- Center offsets
	aX = aX - width / 2
	aY = aY - height / 2

	local sensitivity = MOUSE_SENSITIVITY * 0.01745
	if isSmoothMovementEnabled then
		sensitivity = sensitivity / 3
	end
	if isSmoothMovementEnabled then
		rotationX = rotationX + aX * sensitivity * 0.6
	else
		rotationX = rotationX + aX * sensitivity
	end
	rotationY = rotationY - aY * sensitivity
	-- Wrap angle
	local PI = math.pi
	-- if rotationX > PI then
	-- 	rotationX = rotationX - 2 * PI
	-- elseif rotationX < -PI then
	-- 	rotationX = rotationX + 2 * PI
	-- end
	if rotationY > PI then
		rotationY = rotationY - 2 * PI
	elseif rotationY < -PI then
		rotationY = rotationY + 2 * PI
	end

	-- Angle must be less than abs(PI / 2)
	if rotationY < - PI / 2.05 then
		rotationY = -PI / 2.05
	elseif rotationY > PI / 2.05 then
		rotationY = PI / 2.05
	end
end

local function onKey(key, isDown)
	if not isDown then
		return false
	end
	if key == CONTROLS.TOGGLE_SMOOTH then
		isSmoothMovementEnabled = not isSmoothMovementEnabled
		if isSmoothMovementEnabled then
			enableSmoothMovement()
		else
			disableSmoothMovement()
		end
	elseif key == CONTROLS.ZOOM_IN or key == CONTROLS.ZOOM_OUT then
		adjustFOV(CAMERA_ZOOM_SPEED * (key == CONTROLS.ZOOM_IN and -1 or 1))
	elseif key == CONTROLS.ROLL_CENTER then
		cameraRoll = 0
	elseif key == CONTROLS.NEXT_WEATHER then
		changeWeather(true)
	elseif key == CONTROLS.PREVIOUS_WEATHER then
		changeWeather(false)
	else
		local screenshotBoundKeys = getBoundKeys("screenshot")
		if screenshotBoundKeys then
			for screenshotKey, state in pairs(screenshotBoundKeys) do
				if key == screenshotKey then
					Sound("sound.wav")
				end
			end
		end
	end
end

function enablePhotoMode()
	if photoModeEnabled or localPlayer:getData("dpCore.state") then
		return false
	end
	if localPlayer:getData("activeUI") then
		return false
	end
	localPlayer:setData("activeUI", "photoMode")

	photoModeEnabled = true

	savedWeather = getWeather()
	currentWeather = 0

	for i, weather in pairs(weatherList) do
		if weather.id == savedWeather then
			currentWeather = i
		end
	end

	if localPlayer.vehicle then
		cameraFOV = Camera.getFieldOfView("vehicle")
	else
		cameraFOV = Camera.getFieldOfView("player")
	end

	cameraRoll = 0
	rotationX, rotationY = 0, 0
	mouseFrameDelay, updateFramesDelay = 0, 0
	isSmoothMovementEnabled = false

	cameraSpeed = Vector3(0, 0, 0)
	cameraDirection = Vector3(0, 0, 0)
	cameraPosition = Camera.matrix.position

	-- Make camera look to point where it looked before initialization
	local direction = (Camera.matrix.forward):getNormalized()
	rotationX = math.atan2(direction.x, direction.y)
	if direction.length ~= 0 then
		rotationY = math.asin(direction.z / direction.length)
	end

	-- Hide HUD
	exports.dpHUD:setVisible(false)
	exports.dpNametags:setVisible(false)
	exports.dpChat:setVisible(false)
	exports.dpRadio:setEnabled(false)

	-- Toggle controls
	for i, name in ipairs(controlList) do
		setControlState(name, getControlState(name))
	end
	toggleAllControls(false)

	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientCursorMove", root, onCursorMove)

	PhotoModeHelp.start()
	addEventHandler("onClientRender", root, PhotoModeHelp.draw)
	addEventHandler("onClientKey", root, onKey)

	cameraPositionActual = cameraPosition
	actualRotationX = rotationX
	actualRotationY = rotationY
	cameraRollActual = cameraRoll
	cameraFOVActual = cameraFOV
end

function disablePhotoMode()
	if not photoModeEnabled then
		return
	end
	localPlayer:setData("activeUI", false)
	photoModeEnabled = false
	-- Return camera to player
	setCameraTarget(localPlayer)

	-- Set server time and weather
	setMinuteDuration(1000)
	exports.dpTime:restoreTime()
	setWeather(savedWeather)

	-- Show HUD
	exports.dpHUD:setVisible(true)
	exports.dpNametags:setVisible(true)
	exports.dpChat:setVisible(true)
	exports.dpRadio:setEnabled(true)

	for i, name in ipairs(controlList) do
		setControlState(name, false)
	end
	toggleAllControls(true)

	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientCursorMove", root, onCursorMove)
	removeEventHandler("onClientKey", root, onKey)

	PhotoModeHelp.stop()
	removeEventHandler("onClientRender", root, PhotoModeHelp.draw)
end

bindKey(PHOTO_MODE_KEY, "down", function ()
	if photoModeEnabled then
		disablePhotoMode()
	else
		enablePhotoMode()
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	photoModeEnabled = false
end)

addEventHandler("onClientResourceStop", resourceRoot, function ()
	if photoModeEnabled then
		disablePhotoMode()
	end
end)
