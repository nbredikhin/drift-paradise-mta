MapControls = {}
local screenSize = Vector2(guiGetScreenSize())
local HORIZONTAL_SPEED = 0.1
local MOUSE_DRAG_SPEED = 10
local VERTICAL_SPEED = 0.8
local prevMousePos = Vector2()

local function mouseUp()
	MapCamera.moveHeight(-VERTICAL_SPEED)
end

local function mouseDown()
	MapCamera.moveHeight(VERTICAL_SPEED)
end

local function placeTargetPoint()
	local mx, my = getCursorPosition()
	if not mx then
		return
	end
	mx, my = mx * screenSize.x, my * screenSize.y

	local x, y, z = getWorldFromScreenPosition(mx, my, 100)
	--createVehicle(411, x, y, z)
	--outputDebugString(table.concat({x, y, z}, ", "))
end

function MapControls.start()
	toggleAllControls(false, true, true)
	showCursor(true)

	bindKey("mouse_wheel_up", "down", mouseUp)
	bindKey("mouse_wheel_down", "down", mouseDown)
	bindKey("mouse1", "up", placeTargetPoint)
end

function MapControls.update()
	local mousePos = Vector2(getCursorPosition())
	if getKeyState("arrow_l") then
		MapCamera.movePosition(Vector2(-1, 0) * HORIZONTAL_SPEED)
	end
	if getKeyState("arrow_r") then
		MapCamera.movePosition(Vector2(1, 0) * HORIZONTAL_SPEED)
	end
	if getKeyState("arrow_u") then
		MapCamera.movePosition(Vector2(0, 1) * HORIZONTAL_SPEED)
	end
	if getKeyState("arrow_d") then
		MapCamera.movePosition(Vector2(0, -1) * HORIZONTAL_SPEED)
	end

	if getKeyState("mouse1") then
		local mouseVelocity = mousePos - prevMousePos
		mouseVelocity = Vector2(-mouseVelocity.x, mouseVelocity.y)
		MapCamera.movePosition(mouseVelocity * MOUSE_DRAG_SPEED * ((MapCamera.getHeight() - 5) / 15 + 1))
	end
	prevMousePos = mousePos
end

function MapControls.stop()
	toggleAllControls(true, true, true)
	toggleControl("radar", false)
	showCursor(false)

	unbindKey("mouse_wheel_up", "down", mouseUp)
	unbindKey("mouse_wheel_down", "down", mouseDown)	
	unbindKey("mouse1", "up", placeTargetPoint)
end