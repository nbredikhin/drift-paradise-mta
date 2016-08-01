Particle = newclass "Particle"

function Particle:init()
	self.x = 0
	self.y = 0
	self.z = 0

	self.vx = 0
	self.vy = 0
	self.vz = 0

	self.size = 2
	self.sizeSpeed = 0

	self.color = {255, 255, 255, 255}
	self.friction = 0

	self.lifetime = 0
	self.totalLifetime = 0
	self.fadeOutAt = 0
	self.fadeInAt = 0
	self.texture = nil

	self.rotation = 0
	self.rotationSpeed = 0
end

function Particle:draw()
	if not self.texture then
		return
	end
	local alpha = 255
	if self.lifetime < self.fadeOutAt then
		alpha = 255 / self.fadeOutAt * self.lifetime
	elseif self.lifetime > self.totalLifetime - self.fadeInAt then
		local passedTime = self.totalLifetime - self.lifetime
		alpha = 255 * passedTime / self.fadeInAt
	end
	if alpha > 255 then
		alpha = 255
	end	
	local sizeX = math.cos(self.rotation) * self.size / 2
	local sizeY = math.sin(self.rotation) * self.size / 2
	dxDrawMaterialLine3D(
		self.x + sizeY, 
		self.y,
		self.z + sizeX,

		self.x - sizeY, 
		self.y,
		self.z - sizeX,

		self.texture,

		self.size,
		tocolor(self.color[1], self.color[2], self.color[3], alpha)
	)
end

function Particle:update(deltaTime)
	self.x = self.x + self.vx * deltaTime
	self.y = self.y + self.vy * deltaTime
	self.z = self.z + self.vz * deltaTime

	local fric = (1 - self.friction) * getGameSpeed()
	self.vx = self.vx - self.vx * fric
	self.vy = self.vy - self.vy * fric
	self.vz = self.vz - self.vz * fric

	self.lifetime = self.lifetime - deltaTime
	self.rotation = self.rotation + self.rotationSpeed * deltaTime
	self.size = self.size + self.sizeSpeed * deltaTime
end