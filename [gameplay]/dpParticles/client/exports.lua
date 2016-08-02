function createEmitter(options)
	return ParticlesManager.addEmitter(ParticlesEmitter(options), sourceResourceRoot)
end

function destroyEmitter(id)
	return ParticlesManager.removeEmitterById(id)
end

function setEmitterPosition(id, x, y, z)
	local emitter = ParticlesManager.getEmitterById(id)
	if not emitter then
		return false
	end
	emitter.options.x = x
	emitter.options.y = y
	emitter.options.z = z
	return true
end

function setEmitterOption(id, name, value)
	local emitter = ParticlesManager.getEmitterById(id)
	if not emitter then
		return false
	end
	return emitter:setOption(name, value)
end