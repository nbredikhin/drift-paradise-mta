-- Global script options
dpPhotoModeOptions = {}
dpPhotoModeOptions.CAMERA_MOVE_SPEED = 0.01
dpPhotoModeOptions.CAMERA_ROLL_SPEED = 0.02
dpPhotoModeOptions.MAX_CAMERA_FOV = 100
dpPhotoModeOptions.MIN_CAMERA_FOV = 30
dpPhotoModeOptions.MOUSE_SENSITIVITY = 0.2
dpPhotoModeOptions.MAX_DISTANCE_FROM_PLAYER = 20
dpPhotoModeOptions.SPEED_SLOWER_MUL = 0.1
dpPhotoModeOptions.SPEED_FASTER_MUL = 2.5
dpPhotoModeOptions.SMOOTH_MOVEMENT_SPEED = 0.004
dpPhotoModeOptions.SMOOTH_LOOK_SPEED = 0.002

-- Free look controls
dpPhotoModeOptions.controls = {}
dpPhotoModeOptions.controls.ROLL_RIGHT = "e"
dpPhotoModeOptions.controls.ROLL_LEFT = "q"
dpPhotoModeOptions.controls.MOVE_FORWARD = "w"
dpPhotoModeOptions.controls.MOVE_BACKWARD = "s"
dpPhotoModeOptions.controls.STRAFE_RIGHT = "d"
dpPhotoModeOptions.controls.STRAFE_LEFT = "a"
dpPhotoModeOptions.controls.ZOOM_OUT = "x" 	-- "mouse_wheel_down"
dpPhotoModeOptions.controls.ZOOM_IN = "z" 	-- "mouse_wheel_up"
dpPhotoModeOptions.controls.SPEED_SLOWER = "lalt"
dpPhotoModeOptions.controls.SPEED_FASTER = "lshift"
dpPhotoModeOptions.controls.MOVE_UP = "space"
dpPhotoModeOptions.controls.MOVE_DOWN = "lctrl"
dpPhotoModeOptions.controls.TOGGLE_SMOOTH = "c"

dpPhotoModeOptions.CONTROL_LIST = {"vehicle_left", "vehicle_right", "handbrake"}

-- Freecam position
local cameraPosition = Vector3(0, 0, 0)
local cameraPositionActual = cameraPosition
-- Freecam direction
local cameraDirection = Vector3(0, 0, 0)
-- Freecam speed
local cameraSpeed = Vector3(0, 0, 0)
local cameraFOV = 70
local cameraFOVActual = cameraFOV
local cameraRoll = 0
local cameraRollActual = cameraRoll

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

-- PRIVATE FUNCTIONS --

-- Fills script vars with default values
local function initializeScriptVars()
	cameraPosition,cameraDirection = Vector3(0, 0, 0), Vector3(0, 0, 0)
	cameraSpeed = Vector3(0, 0, 0)
	cameraFOV, cameraRoll = 70, 0

	rotationX, rotationY = 0, 0

	mouseFrameDelay, updateFramesDelay = 0, 0

	isSmoothMovementEnabled = false
end

local function adjustFOV(wheelDir)
	cameraFOV = cameraFOV + wheelDir

	if cameraFOV > dpPhotoModeOptions.MAX_CAMERA_FOV then
		cameraFOV = dpPhotoModeOptions.MAX_CAMERA_FOV
	elseif cameraFOV < dpPhotoModeOptions.MIN_CAMERA_FOV then
		cameraFOV = dpPhotoModeOptions.MIN_CAMERA_FOV
	end
end

local function update(dt)
	if not photoModeEnabled then
		return
	end

	-- If game is actually inactive (working with GUI or so)
	-- Wait for 10 frames after games becomes active, just for smooth
	if isMTAWindowActive() or isCursorShowing() then
		updateFramesDelay = 10
		return
	elseif updateFramesDelay > 0 then
		updateFramesDelay = updateFramesDelay - 1
		return
	end

	-- Adjust camera roll
	if getKeyState(dpPhotoModeOptions.controls.ROLL_RIGHT) then
		cameraRoll = cameraRoll + dpPhotoModeOptions.CAMERA_ROLL_SPEED * dt
	elseif getKeyState(dpPhotoModeOptions.controls.ROLL_LEFT) then
		cameraRoll = cameraRoll - dpPhotoModeOptions.CAMERA_ROLL_SPEED * dt
	end

	-- Adjust zoom
	if getKeyState(dpPhotoModeOptions.controls.ZOOM_IN) then
		adjustFOV(-1)
	elseif getKeyState(dpPhotoModeOptions.controls.ZOOM_OUT) then
		adjustFOV(1)
	end

	local cameraForward = Camera.matrix.forward
	local cameraRight = Vector3(cameraForward.y, -cameraForward.x, 0):getNormalized()
	cameraSpeed = Vector3(0, 0, 0)

	-- Move camera
	if getKeyState(dpPhotoModeOptions.controls.MOVE_FORWARD) then
		cameraSpeed = cameraSpeed + cameraForward
	elseif getKeyState(dpPhotoModeOptions.controls.MOVE_BACKWARD) then
		cameraSpeed = cameraSpeed - cameraForward
	end

	if getKeyState(dpPhotoModeOptions.controls.STRAFE_RIGHT) then
		cameraSpeed = cameraSpeed + cameraRight
	elseif getKeyState(dpPhotoModeOptions.controls.STRAFE_LEFT) then
		cameraSpeed = cameraSpeed - cameraRight
	end

	if getKeyState(dpPhotoModeOptions.controls.MOVE_UP) then
		cameraSpeed = cameraSpeed + Vector3(0, 0, 0.1)
	elseif getKeyState(dpPhotoModeOptions.controls.MOVE_DOWN) then
		cameraSpeed = cameraSpeed - Vector3(0, 0, 0.1)
	end

	cameraSpeed = dpPhotoModeOptions.CAMERA_MOVE_SPEED * cameraSpeed:getNormalized()
	if getKeyState(dpPhotoModeOptions.controls.SPEED_SLOWER) then
		cameraSpeed = cameraSpeed * dpPhotoModeOptions.SPEED_SLOWER_MUL
	elseif getKeyState(dpPhotoModeOptions.controls.SPEED_FASTER) then
		cameraSpeed = cameraSpeed * dpPhotoModeOptions.SPEED_FASTER_MUL
	end
	cameraPosition = cameraPosition + dt * cameraSpeed

	local distance = cameraPosition - localPlayer.position
	if (distance.length) > dpPhotoModeOptions.MAX_DISTANCE_FROM_PLAYER then
		cameraPosition = localPlayer.position +
		 distance:getNormalized() * dpPhotoModeOptions.MAX_DISTANCE_FROM_PLAYER
	end

	if isSmoothMovementEnabled then
		rotationX = rotationX * 0.97
		cameraPositionActual = cameraPositionActual + (cameraPosition - cameraPositionActual) * dt * dpPhotoModeOptions.SMOOTH_MOVEMENT_SPEED
		actualRotationX = actualRotationX + rotationX * dt * dpPhotoModeOptions.SMOOTH_LOOK_SPEED
		actualRotationY = actualRotationY + exports.dpUtils:differenceBetweenAnglesRadians(actualRotationY, rotationY) * dt * dpPhotoModeOptions.SMOOTH_LOOK_SPEED
		cameraRollActual = cameraRollActual + (cameraRoll - cameraRollActual) * dt * dpPhotoModeOptions.SMOOTH_MOVEMENT_SPEED
		cameraFOVActual = cameraFOVActual + (cameraFOV - cameraFOVActual) * dt * dpPhotoModeOptions.SMOOTH_MOVEMENT_SPEED
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

	--cameraPositionActual = cameraPosition
	--cameraDirectionActual = cameraDirection
	--cameraRollActual = cameraRoll
	--cameraFOVActual = cameraFOV
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

	local sensitivity = dpPhotoModeOptions.MOUSE_SENSITIVITY * 0.01745
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
	if key == dpPhotoModeOptions.controls.TOGGLE_SMOOTH then
		isSmoothMovementEnabled = not isSmoothMovementEnabled
		if isSmoothMovementEnabled then
			rotationX = 0
		end
	end
end

-- PUBLIC FUNCTIONS --

function enablePhotoMode()
	if photoModeEnabled or localPlayer:getData("dpCore.state") then
		return
	end
	if localPlayer:getData("activeUI") then
		return false
	end
	localPlayer:setData("activeUI", "photoMode")

	photoModeEnabled = true
	initializeScriptVars()

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

	for i, name in ipairs(dpPhotoModeOptions.CONTROL_LIST) do
		setControlState(name, getControlState(name))
	end

	toggleAllControls(false)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientCursorMove", root, onCursorMove)

	PhotoModeHelp.start()
	addEventHandler("onClientRender", root, PhotoModeHelp.draw)
	addEventHandler("onClientKey", root, onKey)

	playSound("sound.wav")

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

	-- Show HUD
	exports.dpHUD:setVisible(true)
	exports.dpNametags:setVisible(true)
	exports.dpChat:setVisible(true)

	for i, name in ipairs(dpPhotoModeOptions.CONTROL_LIST) do
		setControlState(name, false)
	end
	toggleAllControls(true)

	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientCursorMove", root, onCursorMove)
	removeEventHandler("onClientKey", root, onKey)

	PhotoModeHelp.stop()
	removeEventHandler("onClientRender", root, PhotoModeHelp.draw)
end

-- For debug purposes
bindKey("o", "down", function ()
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