--- Синхронизация текстуры кузова (наклеек)
-- @script dpVehicles.body_texture

BODY_TEXTURE_NAME = "body"

local TEXTURE_SIZE = 1024
local STICKER_SIZE = 300
local mainRenderTarget = dxCreateRenderTarget(TEXTURE_SIZE, TEXTURE_SIZE, true)
local vehicleRenderTarget
local stickersTextures = {}
local selectionTexture

local function drawSticker(sticker, selected)
	local x, y, width, height, stickerId, rotation, color, mirror, mirrorText = unpack(sticker)
	if  type(x) ~= "number" or 
		type(y) ~= "number" or 
		type(width) ~= "number" or 
		type(height) ~= "number" or
		type(stickerId) ~= "number"
	then
		return
	end
	local texture = stickersTextures[stickerId]
	if not isElement(texture) then
		stickersTextures[stickerId] = exports.dpAssets:createTexture("stickers/" .. tostring(stickerId) .. ".png")
		texture = stickersTextures[stickerId]
	end
	if selected then
		dxDrawImage(x - width / 2, y - height / 2, width, height, selectionTexture, rotation)
	end
	dxDrawImage(x - width / 2, y - height / 2, width, height, texture, rotation, 0, 0, color)
	-- Отраженная наклейка
	if mirror then
		if mirrorText then
			dxDrawImage(TEXTURE_SIZE - x - width / 2 + width, y - height / 2 + height, -width, -height, texture, 180-rotation, 0, 0, color)
		else
			dxDrawImage(TEXTURE_SIZE - x - width / 2, y - height / 2, width, height, texture, 180-rotation, 0, 0, color)
		end
	end
end

function redrawBodyRenderTarget(renderTarget, bodyColor, bodyTexture, stickers, selected)
	if not isElement(renderTarget) then
		return
	end
	if not selected then
		selected = 0
	end
	dxSetRenderTarget(renderTarget, true)
	if bodyColor then
		dxDrawRectangle(0, 0, TEXTURE_SIZE, TEXTURE_SIZE, tocolor(bodyColor[1], bodyColor[2], bodyColor[3]))
	end
	if bodyTexture then

	end
	if type(stickers) == "table" then
		for i, sticker in ipairs(stickers) do
			drawSticker(sticker, selected == i)
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
	if isElementLocal(vehicle) or vehicle:getData("localVehicle") then
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
	pixels = nil
end

-- Обновить текстуры всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	selectionTexture = dxCreateTexture("assets/selection.png")
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleTexture(vehicle)
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleTexture(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupVehicleTexture(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if isElement(vehicleRenderTarget) then
		return
	end
	if dataName == "BodyColor" or dataName == "stickers" then
		setupVehicleTexture(source)
	end
end)