local BODY_TEXTURE_NAME = "body"
local shaders = {}
local isVisible = false

local function replaceTexture(vehicle, textureName, texture)
	if not isElement(vehicle) or type(textureName) ~= "string" or not isElement(texture) then
		return false
	end
	local shader = shaders[vehicle]
	if isElement(shader) then
		destroyElement(shader) 
		shader = nil
	end
	if not isElement(shader) then
		-- Создание нового шейдера
		shader = dxCreateShader("texture_replace.fx")
	end
	-- Не удалось создать шейдер
	if not shader then
		return false
	end
	engineApplyShaderToWorldTexture(shader, textureName, vehicle)
	shader:setValue("gTexture", texture)
	shaders[vehicle] = shader
	return true
end

bindKey("m", "down", function ()
	if isVisible then
		for k, v in pairs(shaders) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		shaders = {}
	else
		local texture = dxCreateTexture("image.png")
		for k, vehicle in pairs(getElementsByType("vehicle")) do
			replaceTexture(vehicle, BODY_TEXTURE_NAME, texture)
		end
		destroyElement(texture)	
	end
	isVisible = not isVisible
end)