CircleButton3D = Clickable:subclass "CircleButton3D"
local SIZE = 64

function CircleButton3D:init(icon)
	self.super:init()
	self.worldPosition = Vector3()
	self.texture = "assets/images/circle_button.png"
	self.width = SIZE
	self.height = SIZE
	self.centerX = 0.5
	self.centerY = 0.5
end

function CircleButton3D:setOffset(offset)
	local vehicle = GarageCar.getVehicle()
	if not isElement(vehicle) then
		return false
	end
	if type(offset) == "string" then
		local componentOffset = Vector3(vehicle:getComponentPosition(v))
		self.worldPosition = vehicle.matrix:transformPosition(componentOffset)
	elseif type(offset) == "userdata" then
	 	self.worldPosition = vehicle.matrix:transformPosition(offset)
	else
		error("CircleButton3D.setOffset: bad argument #1. Expected string or Vector3, got "..type(offset))
	end
	return true
end

function CircleButton3D:update(dt)
	self.super:update()
	local x, y = getScreenFromWorldPosition(self.worldPosition)
	self.isVisible = not not x
	if self.isVisible then
		self.x = x
		self.y = y
	end
end

function CircleButton3D:draw()
	if self.isVisible then
		local color = tocolor(255, 0, 0, 200)
		if self.mouseHover then
			color = tocolor(255, 255, 255, 255)
		end
		dxDrawImage(self.x - self.width / 2, self.y - self.height / 2, self.width, self.height, self.texture, 0, 0, 0, color)
	end
end