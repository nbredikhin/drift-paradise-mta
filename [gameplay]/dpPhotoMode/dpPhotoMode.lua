-- Global script options
dpPhotoModeOptions = {}
dpPhotoModeOptions.CAMERA_MOVE_SPEED = 0.01
dpPhotoModeOptions.CAMERA_ROLL_SPEED = 0.02
dpPhotoModeOptions.MAX_CAMERA_FOV = 100
dpPhotoModeOptions.MIN_CAMERA_FOV = 45
dpPhotoModeOptions.MOUSE_SENSITIVITY = 0.2
dpPhotoModeOptions.MAX_DISTANCE_FROM_PLAYER = 10
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
dpPhotoModeOptions.controls.SPEED_MODYFIER = "lalt"
dpPhotoModeOptions.controls.MOVE_UP = "space"
dpPhotoModeOptions.controls.MOVE_DOWN = "lctrl"

dpPhotoModeOptions.CONTROL_LIST = {"vehicle_left", "vehicle_right", "handbrake"}

-- Freecam position
local cameraPosition = Vector3(0, 0, 0)
-- Freecam direction
local cameraDirection = Vector3(0, 0, 0)
-- Freecam speed
local cameraSpeed = Vector3(0, 0, 0)
local cameraFOV = 70
local cameraRoll = 0

-- Polar angle
local rotationX = 0
-- Azimuthal angle
local rotationY = 0

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
end

local function onStartup()
	photoModeEnabled = false
end

local function onShutdown()
	if photoModeEnabled then
		disablePhotoMode()
	end
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
	if getKeyState(dpPhotoModeOptions.controls.SPEED_MODYFIER) then
		cameraSpeed = cameraSpeed * 0.1
	end

	cameraPosition = cameraPosition + dt * cameraSpeed

	local distance = cameraPosition - localPlayer.position
	if (distance.length) > dpPhotoModeOptions.MAX_DISTANCE_FROM_PLAYER then 
		cameraPosition = localPlayer.position +
		 distance:getNormalized() * dpPhotoModeOptions.MAX_DISTANCE_FROM_PLAYER
	end

	cameraDirection.x = cameraPosition.x + dt * 100 * math.cos(rotationY) * math.sin(rotationX)
	cameraDirection.y = cameraPosition.y + dt * 100 * math.cos(rotationY) * math.cos(rotationX)
	cameraDirection.z = cameraPosition.z + dt * 100 * math.sin(rotationY)
	
	setCameraMatrix(cameraPosition, cameraDirection, cameraRoll, cameraFOV)
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

	rotationX = rotationX + aX * dpPhotoModeOptions.MOUSE_SENSITIVITY * 0.01745
	rotationY = rotationY - aY * dpPhotoModeOptions.MOUSE_SENSITIVITY * 0.01745

	-- Wrap angle
	local PI = math.pi
	if rotationX > PI then 
		rotationX = rotationX - 2 * PI
	elseif rotationX < -PI then
		rotationX = rotationX + 2 * PI
	end

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

-- PUBLIC FUNCTIONS --

function enablePhotoMode()
	if photoModeEnabled or localPlayer:getData("dpCore.state") then 
		return
	end

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
	showChat(false)

	for i, name in ipairs(dpPhotoModeOptions.CONTROL_LIST) do
		setControlState(name, getControlState(name))
	end

	toggleAllControls(false)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientCursorMove", root, onCursorMove)
end

function disablePhotoMode()
	if not photoModeEnabled then
		return
	end
	photoModeEnabled = false
	-- Return camera to player
	setCameraTarget(localPlayer)
	
	-- Show HUD
	exports.dpHUD:setVisible(true)
	showChat(true)

	for i, name in ipairs(dpPhotoModeOptions.CONTROL_LIST) do
		setControlState(name, false)
	end

	toggleAllControls(true)

	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientCursorMove", root, onCursorMove)
end

-- For debug purposes
addCommandHandler("e", enablePhotoMode)
addCommandHandler("d", disablePhotoMode)

addEventHandler("onClientResourceStart", root, onStartup)
addEventHandler("onClientResourceStop", root, onShutdown)