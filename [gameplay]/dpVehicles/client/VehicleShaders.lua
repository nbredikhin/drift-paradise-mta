VehicleShaders = {}

-- Активные шейдеры на автомобилях
local shaders = {}

-- Удаление всех шейдеров с автомобиля
local function destroyVehicleShaders(vehicle)
	for shaderName in pairs(shaders) do
		local shader = shaders[shaderName][vehicle]
		if isElement(shader) then
			destroyElement(shader)
		end
	end
end

function VehicleShaders.hasTexture(vehicle, textureName)
	return not not shaders[shaderName][vehicle]
end

-- Замена текстуры с именем textureName на автомобиле
function VehicleShaders.replaceTexture(vehicle, textureName, texture)
	if not isElement(vehicle) or type(textureName) ~= "string" or not isElement(texture) then
		return false
	end
	local shaderName = "texture_" .. tostring(textureName)
	if not shaders[shaderName] then
		shaders[shaderName] = {}
	end
	local shader = shaders[shaderName][vehicle]
	if isElement(shader) then
		destroyElement(shader) 
		shader = nil
	end
	if not isElement(shader) then
		-- Создание нового шейдера
		shader = exports.dpAssets:createShader("texture_replace.fx")
	end
	-- Не удалось создать шейдер
	if not shader then
		return false
	end
	engineApplyShaderToWorldTexture(shader, textureName, vehicle)
	shader:setValue("gTexture", texture)
	shader:setData("shader_type", "texture", false)
	shaders[shaderName][vehicle] = shader
	return true
end

function VehicleShaders.replaceColor(vehicle, textureName, r, g, b)
	-- TODO:
end

addEventHandler("onClientElementDestroy", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	destroyVehicleShaders(source)
end)

addEventHandler("onClientElementStreamOut", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	destroyVehicleShaders(source)
end)

addEventHandler("onClientVehicleExplode", root, function ()
	if source.type ~= "vehicle" then
		return
	end
	destroyVehicleShaders(source)
end)