ParticlesEmitter = newclass "ParticlesEmitter"

local types = {
	smoke = 3 
}

local textureCache = {}

local function getCachedTexture(name)
	if textureCache[name] then
		return textureCache[name]
	end

	textureCache[name] = dxCreateTexture(name, "dxt5")
	return textureCache[name]
end

local DEFAULT_OPTIONS = {
	type = "smoke",
	speed = {-0.5, 0.5},
	friction = 0.98,
	forceX = 0,
	forceY = 0,
	forceZ = 0.03,

	x = 0,
	y = 0,
	z = 0,

	lifetime = {4, 5},
	delay = 0.2,
	density = 1,
	fadeOutAt = 2,
	fadeInAt = 0.2,

	startSize = {0.5, 1},
	endSize = {4, 6},

	rotation = 0,
	rotationSpeed = 10,

	r = 255,
	g = 255,
	b = 255,
	alpha = 1
}

function ParticlesEmitter:init(options)	
	self.particles = {}
	self.particlesCount = 0
	self:setOptions(options)
	self.textures = {}
	self.currentTexture = 1
	for i = 1, types[options.type] do
		self.textures[i] = getCachedTexture("assets/" .. tostring(self.options.type) .. tostring(i) .. ".png")
	end

	self.delay = 0
end

function ParticlesEmitter:setOptions(options)
	if type(options) ~= "table" then
		return false
	end
	self.options = options
	for k, v in pairs(DEFAULT_OPTIONS) do
		if self.options[k] == nil then
			self.options[k] = v
		end
	end
	return true
end

function ParticlesEmitter:setOption(name, value)
	if type(name) ~= "string" then
		return false
	end
	if value == nil then
		self.options[name] = DEFAULT_OPTIONS[name]
	else
		self.options[name] = value
	end
	return true
end

function ParticlesEmitter:getRandomOption(name)
	local value = self.options[name]
	if not value then
		value = DEFAULT_OPTIONS[name]
		if not value then
			return 0
		end
	end
	if type(value) == "table" then
		return value[1] + math.random() * (value[2] - value[1])
	end
	return math.random() * value
end

function ParticlesEmitter:addParticle(particle)
	for i = 1, #self.particles do
		if not self.particles[i] then
			self.particles[i] = particle
			return
		end
	end
	if not index then
		self.particlesCount = self.particlesCount + 1
		self.particles[self.particlesCount] = particle
	end
	return true
end

function ParticlesEmitter:setRunning(running)

end

function ParticlesEmitter:emit()
	for i = 1, self.options.density do
		local particle = Particle()
		particle.texture = self.textures[math.random(1, #self.textures)]
		particle.totalLifetime = self:getRandomOption("lifetime")
		particle.lifetime = particle.totalLifetime

		particle.x = self.options.x
		particle.y = self.options.y
		particle.z = self.options.z

		particle.vx = self:getRandomOption("speed")
		particle.vy = self:getRandomOption("speed")
		particle.vz = self:getRandomOption("speed")

		particle.color = {
			self.options.r,
			self.options.g,
			self.options.b,
		}

		particle.fadeOutAt = self.options.fadeOutAt
		particle.fadeInAt = self.options.fadeInAt
		particle.size = self:getRandomOption("startSize")
		particle.sizeSpeed = (self:getRandomOption("endSize") - particle.size) / particle.lifetime

		particle.rotation = self:getRandomOption("rotation") / 180 * math.pi
		particle.rotationSpeed = self:getRandomOption("rotationSpeed") / 180 * math.pi

		particle.alpha = self.options.alpha

		particle.friction = self.options.friction		
		self:addParticle(particle)
	end
end

function ParticlesEmitter:draw()
	for i = 1, self.particlesCount do
		local particle = self.particles[i]
		if particle then
			particle:draw()
		end
	end
end

function ParticlesEmitter:update(deltaTime)
	local gameSpeed = getGameSpeed()
	deltaTime = deltaTime * gameSpeed
	for i = 1, self.particlesCount do
		local particle = self.particles[i]
		if particle then
			particle:update(deltaTime)
			particle.vx = particle.vx + self.options.forceX * deltaTime
			particle.vy = particle.vy + self.options.forceY * deltaTime
			particle.vz = particle.vz + self.options.forceZ * deltaTime
			if particle.lifetime < 0 then
				self.particles[i] = nil
				if i == self.particlesCount then
					self.particlesCount = self.particlesCount - 1
				end
			end
		end
	end

	self.delay = self.delay - deltaTime
	if self.delay * gameSpeed < 0 then
		self.delay = self.options.delay
		self:emit()
	end
end