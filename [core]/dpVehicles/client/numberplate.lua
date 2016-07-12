local NUMBERPLATE_TEXTURE_NAME = "nomer"
local NUMBERPLATE_WIDTH = 256
local NUMBERPLATE_HEIGHT = 128

local mainRenderTarget = dxCreateRenderTarget(NUMBERPLATE_WIDTH, NUMBERPLATE_HEIGHT, true)

local backgroundTexture
local textFont

local textOffsetX = 10
local textOffsetY = 17
local textWidth = 229
local textSize = 36
local textHeight = 128

function drawNumberplate(renderTarget, text)
	if not isElement(renderTarget) then
		return
	end
	dxSetRenderTarget(renderTarget, true)
	dxDrawImage(0, 0, NUMBERPLATE_WIDTH, NUMBERPLATE_HEIGHT, backgroundTexture)
	dxDrawText(tostring(text), textOffsetX, 0, textOffsetX + textWidth, textOffsetY + textHeight, tocolor(0, 0, 0, 230), 1, textFont, "center", "center")
	dxSetRenderTarget()
end

local function setupVehicleNumberplate(vehicle)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return
	end
	local numberplate = vehicle:getData("Numberplate")
	drawNumberplate(mainRenderTarget, numberplate)
	-- Копирование содержимого renderTarget'а в текстуру
	local pixels = dxGetTexturePixels(mainRenderTarget)
	local texture = dxCreateTexture(NUMBERPLATE_WIDTH, NUMBERPLATE_HEIGHT)
	dxSetTexturePixels(texture, pixels)
	-- Применение текстуры к автомобилю
	VehicleShaders.replaceTexture(vehicle, NUMBERPLATE_TEXTURE_NAME, texture)
	destroyElement(texture)
end

-- Обновить номеров всех видимых машин при запуске скрипта
addEventHandler("onClientResourceStart", resourceRoot, function()
	backgroundTexture = dxCreateTexture("assets/numberplate.png")
	textFont = dxCreateFont("assets/numberplate.ttf", textSize)
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleNumberplate(vehicle)
	end
end)

addEventHandler("onClientRestore", root, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		setupVehicleNumberplate(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		setupVehicleNumberplate(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source.type ~= "vehicle" then
		return
	end
	if dataName == "Numberplate" then
		setupVehicleNumberplate(source)
	end
end)