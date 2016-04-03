local ASSETS_PATH = "assets/"
local SHADERS_PATH = "shaders/"
local TEXTURES_PATH = "textures/"

local cache = {
	textures = {},
	shaders = {}
}

local function setupElementParent(element, resource)
	if not element or not resource then
		return false
	end
	element.parent = getResourceDynamicElementRoot(resource)
	return true
end

function createShader(name, ...)
	local element = dxCreateShader(ASSETS_PATH .. SHADERS_PATH .. tostring(name), ...)
	setupElementParent(element, sourceResource)
	return element
end

function createTexture(name, ...)
	local element = dxCreateTexture(ASSETS_PATH .. TEXTURES_PATH .. tostring(name), ...)
	setupElementParent(element, sourceResource)
	return element	
end

function createShaderCached(name, ...)
	if not name then
		return false
	end
	if cache.shaders[name] then
		return cache.shaders[name]
	end
	cache.shaders[name] = createShader(name, ...)
	setupElementParent(cache.shaders[name], sourceResource)
	return cache.shaders[name]
end

function createTextureCached(name, ...)
	if not name then
		return false
	end
	if cache.textures[name] then
		return cache.textures[name]
	end
	cache.textures[name] = createTexture(name, ...)
	setupElementParent(cache.textures[name], sourceResource)
	return cache.textures[name]
end