TuningMenu = newclass "TuningMenu"

function TuningMenu:init(position, rotation, size)
	check("TuningMenu:new", {
		{position, "userdata"},
		{rotation, "number"},
		{size, "userdata"},
	})

	self.position = position
	self.rotation = rotation
	self.size = size
	-- Разрешение рендеринга
	self.resolution = self.size * 250

	self.renderTarget = dxCreateRenderTarget(self.resolution.x, self.resolution.y, true)
end

function TuningMenu:draw(fadeProgress)
	local halfHeight = Vector3(0, 0, self.size.y / 2)
	local rad = math.rad(self.rotation)
	local lookOffset = Vector3(math.cos(rad), math.sin(rad), 0)
	dxDrawMaterialLine3D(
		self.position + halfHeight, 
		self.position - halfHeight, 
		self.renderTarget, 
		self.size.x, 
		tocolor(255, 255, 255, 240 * fadeProgress),
		self.position + lookOffset
	)
end

function TuningMenu:update(deltaTime)
end

function TuningMenu:destroy()
	if isElement(self.renderTarget) then
		destroyElement(self.renderTarget)
	end
end