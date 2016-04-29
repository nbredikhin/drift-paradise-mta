CarSelectScreen = Screen:subclass "CarSelectScreen"

function CarSelectScreen:init()
	self.super:init()
	self.btn = CircleButton3D:new("select")
	self:addChild(self.btn)
end

function CarSelectScreen:onShow()
	self.btn:setOffset(Vector3(0, 0, 1))
end