BODY_TEXTURE_NAME = "body"

local vehicleShaders = {}
local TEXTURE_SIZE = 1024
local STICKER_SIZE = 300
local mainRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)
local vehicleRenderTarget

local function drawSticker(sticker)
	local x, y, width, height, stickerId, rotation, color = unpack(sticker)
	if  type(x) ~= "number" or 
		type(y) ~= "number" or 
		type(width) ~= "number" or 
		type(height) ~= "number" or
		type(stickerId) ~= "number"
	then
		return
	end
	local texture = dxCreateTexture(1, 1) -- TODO: Load sticker
	dxDrawImage(x, y, width, height, texture, rotation, 0, 0, color)
end

function redrawBodyRenderTarget(renderTarget, bodyColor, bodyTexture, stickers)
	if not isElement(renderTarget) then
		return
	end
	dxSetRenderTarget(renderTarget, true)
	if bodyColor then
		dxDrawRectangle(0, 0, TEXTURE_SIZE, TEXTURE_SIZE, tocolor(bodyColor[1], bodyColor[2], bodyColor[3]))
	end
	if bodyTexture then

	end
	if type(stickers) == "table" then
		for i, sticker in ipairs(stickers) do
			drawSticker(sticker)
		end
	end
	dxSetRenderTarget()
end

function createVehicleRenderTarget(vehicle)
	if not isElement(vehicle) then
		return
	end
	if isElement(vehicleRenderTarget) then
		destroyElement(vehicleRenderTarget)
	end
	vehicleRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE)
	VehicleShaders.replaceTexture(vehicle, BODY_TEXTURE_NAME, vehicleRenderTarget)
	return vehicleRenderTarget
end

local function setupVehicleTexture(vehicle)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return
	end
	if isElementLocal(vehicle) then
		return
	end
	local bodyColor = vehicle:getData("BodyColor")
	local bodyTexture = vehicle:getData("BodyTexture")
	local stickers = vehicle:getData("stickers")
	redrawBodyRenderTarget(mainRenderTarget, bodyColor, bodyTexture, stickers)
	-- Копирование содержимого renderTarget'а в текстуру
	local pixels = dxGetTexturePixels(mainRenderTarget)
	local texture = dxCreateTexture(TEXTURE_SIZE, TEXTURE_SIZE)
	dxSetTexturePixels(texture, pixels)
	-- Применение текстуры к автомобилю
	VehicleShaders.replaceTexture(vehicle, BODY_TEXTURE_NAME, texture)
	destroyElement(texture)
	texture = nil
	pixel = nil
end

-- Обновить текстуры всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleTexture(vehicle)
	end
end)


addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupVehicleTexture(source)
	end
end)

-- addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
-- 	if source.type == "vehicle" then
-- 		if dataName == "tuning_texture_preview" and oldValue == source:getData(dataName) then
-- 			return
-- 		end
-- 		if dataName == "stickers" or dataName == "BodyColor" or dataName == "BodyTexture" or dataName == "tuning_texture_preview" then
-- 			setupVehicleTexture(source)
-- 		end
-- 		-- if source:getData("tuning_texture_preview") and dataName == "tuning_texture_preview" then
-- 		-- 	setupVehicleTexture(source)
-- 		-- elseif dataName == "stickers" or dataName == "BodyColor" or dataName == "BodyTexture" then
-- 		-- 	setupVehicleTexture(source)
-- 		-- end
-- 	end
-- end)