ParticlesManager = {}
local emittersCount = 0
local emitters = {}

function ParticlesManager.addEmitter(emitter, resource)
	if type(emitter) ~= "table" then
		return false
	end
	if isElement(resource) then
		emitter.resource = resource
	end
	if emittersCount == 0 then
		emitters = {emitter}
		emittersCount = 1
		return emittersCount
	end
	for i = 1, emittersCount do
		if not emitters[i] then
			emitters[i] = emitter
			return i
		end
	end
	emittersCount = emittersCount + 1
	emitters[emittersCount] = emitter
	return emittersCount
end

function ParticlesManager.removeEmitterById(id)
	if type(id) ~= "number" then
		return false
	end
	emitters[id] = nil
	if id == emittersCount then
		emittersCount = emittersCount - 1
	end
end

function ParticlesManager.getEmitterById(id)
	if type(id) ~= "number" then
		return
	end
	return emitters[id]
end

addEventHandler("onClientRender", root, function ()
	for i = 1, emittersCount do
		if emitters[i] then
			emitters[i]:draw()
		end
	end
end)

addEventHandler("onClientPreRender", root, function (deltaTime)
	deltaTime = deltaTime / 1000

	for i = 1, emittersCount do
		if emitters[i] then
			emitters[i]:update(deltaTime)
		end
	end
end)

addEventHandler("onClientResourceStop", root, function ()
	for i = 1, emittersCount do
		if emitters[i] and emitters[i].resource == source then
			ParticlesManager.removeEmitterById(i)
		end
	end
end)