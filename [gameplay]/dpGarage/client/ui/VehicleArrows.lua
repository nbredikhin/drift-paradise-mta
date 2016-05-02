VehicleArrows = {}
local screenSize = Vector2(guiGetScreenSize())
local positionLeft = Vector3()
local positionRight = Vector3()
local arrowSize = 0.15
local arrowColor = tocolor(255, 255, 255, 230)

function VehicleArrows.setPosition(posLeft, posRight)
	if posLeft then
		positionLeft = posLeft
	end
	if posRight then
		positionRight = posRight
	end
end

function VehicleArrows.setSize(size)
	if type(size) ~= "number" then
		return
	end
	arrowSize = size
end

function VehicleArrows.setColor(...)
	arrowColor = tocolor(...)
end

function VehicleArrows.draw()
	local x1, y1 = getScreenFromWorldPosition(positionLeft)
	local x2, y2 = getScreenFromWorldPosition(positionRight)
	if not x1 or not x2 then
		return
	end	
	local y = y1 + math.abs(y1 - y2) / 2

	local size = screenSize.y * arrowSize
	local animationOffset = size * 0.05 * math.sin(getTickCount() / 200)
	dxDrawImage(x1 - size / 2 + animationOffset, y - size / 2, size, size, Assets.textures.arrow, 180, 0, 0, arrowColor)
	dxDrawImage(x2 - size / 2 - animationOffset, y - size / 2, size, size, Assets.textures.arrow, 0, 0, 0, arrowColor)
end