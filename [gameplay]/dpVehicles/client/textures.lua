BODY_TEXTURE_NAME = "body"

local vehicleShaders = {}

local function applyVehicleTexture(vehicle)
	if not isElement(vehicle) then
		return false
	end
	if not isElementStreamedIn(vehicle) then
		return false
	end
	-- Если для машины не создан шейдер, создать его
	if not isElement(vehicleShaders[vehicle]) then
		-- TODO: Создание шейдера
		local shader = exports.dpAssets:createShader("texture_replace.fx")
		engineApplyShaderToWorldTexture(shader, BODY_TEXTURE_NAME, vehicle)

		local texture = exports.dpAssets:createTexture("logo.png")
		shader:setValue("gTexture", texture)
		destroyElement(texture)
		vehicleShaders[vehicle] = shader
	else
		local shader = vehicleShaders[vehicle].shader
	end
	return true
end

local function removeVehicleTexture(vehicle)
	if not isElement(vehicleShaders[vehicle]) then
		return false
	end
	destroyElement(vehicleShaders[vehicle])
	vehicleShaders[vehicle] = nil
	return true
end

-- Обновить текстуры всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		applyVehicleTexture(vehicle)
	end
end)

-- Применение текстуры
addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		applyVehicleTexture(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName)
	if source.type == "vehicle" and dataName == "texture" then
		applyVehicleTexture(source)
	end
end)

-- Удаление текстуры
addEventHandler("onClientElementStreamOut", root, function()
	if source.type == "vehicle" then
		removeVehicleTexture(source)
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if source.type == "vehicle" then
		removeVehicleTexture(source)
	end
end)