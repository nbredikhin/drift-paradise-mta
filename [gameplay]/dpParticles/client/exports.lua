function createParticlesEmitter(options)
	return ParticlesManager.addEmitter(ParticlesEmitter(options))
end

function destroyParticlesEmitter(id)
	return ParticlesManager.removeEmitterById(id)
end

function setEmitterOptions(id, options)

end