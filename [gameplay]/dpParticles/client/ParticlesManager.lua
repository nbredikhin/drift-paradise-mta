ParticlesManager = {}
local emitters = {}

function ParticlesManager.addEmitter(emitter)
	table.insert(emitters, emitter)	
end

function ParticlesManager.removeEmitterById(id)

end

addEventHandler("onClientRender", root, function ()
	for i, e in ipairs(emitters) do
		e:draw()
	end
end)

addEventHandler("onClientPreRender", root, function (deltaTime)
	deltaTime = deltaTime / 1000

	for i, e in ipairs(emitters) do
		e:update(deltaTime)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	local emitter = ParticlesEmitter({
		positionX = -29,
		positionY = 1770, 
		positionZ = 17
	})
	ParticlesManager.addEmitter(emitter)
end)