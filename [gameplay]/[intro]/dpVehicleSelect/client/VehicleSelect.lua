local DEBUG_AUTOSTART = false

VehicleSelect = {}
local screenWidth, screenHeight = guiGetScreenSize()

local isActive = false
local positions = {
	Vector3 { x = 2916.601, y = -3170.575, z = 2535.244 },
	Vector3 { x = 2913.580, y = -3178.015, z = 2535.244 },
	Vector3 { x = 2915.438, y = -3186.282, z = 2535.244 }
}

local rotations = {137, 217, 270}
local CAMERA_POSITION = Vector3  { x = 2915.162, y = -3175.603, z = 2536.517 }
local cameraPositions = {
	Vector3 { x = 2915.381, y = -3177.743, z = 2536.517 },
	Vector3 { x = 2915.142, y = -3185.672, z = 2537.119 },
	Vector3 { x = 2921.819, y = -3181.869, z = 2536.942 }
}

local targetPosition = cameraPositions[1]
local currentPosition = targetPosition
local targetLookPosition = positions[1]
local currentLookPosition = targetLookPosition

local currentVehicle = 1

local vehicles = {}
local isSelected = false
local textures = {}
local imageSize = 1.5

local function update(dt)
	local shakeX = math.sin(getTickCount() / 740) * (math.sin(getTickCount() / 300) + 1) * 0.005
	local shakeY = math.cos(getTickCount() / 250) * (math.sin(getTickCount() / 300) + 1) * 0.001
	local shakeZ = math.sin(getTickCount() / 430) * (math.cos(getTickCount() / 600) + 1) * 0.005
	local offset = Vector3(shakeX, shakeY, shakeZ)
	local deltaTime = dt / 1000
	currentLookPosition = currentLookPosition + (targetLookPosition - currentLookPosition) * 1 * deltaTime
	currentLookPosition = currentLookPosition + offset / 4

	currentPosition = currentPosition + (targetPosition - currentPosition) * 1.5 * deltaTime
	currentPosition = currentPosition - offset / 6
	Camera.setMatrix(currentPosition, currentLookPosition + Vector3(0, 0, 0), 0, 50)
end

local function drawTexture3D(position, texture)
	dxDrawMaterialLine3D(
		position + Vector3(0, 0, imageSize / 2), 
		position - Vector3(0, 0, imageSize / 2),
		texture,
		imageSize,
		tocolor(255, 255, 255, 220)
	)
end

local function draw()
	drawTexture3D(positions[1] + Vector3(1.5, -1.5, 0.2), textures.car1)
	drawTexture3D(positions[2] + Vector3(-1.5, -1.5, 0.2), textures.car1)
	drawTexture3D(positions[3] + Vector3(0, 2, 0.2), textures.car1)
	dxDrawImage(0, 0, screenWidth, screenHeight, textures.shadow)
end

local function onKey(key, state)
	if not state then
		return
	end
	if isSelected then
		return
	end
	if key == "enter" then
		isSelected = true
		setTimer(function()
			triggerServerEvent("dpVehicleSelect.selected", resourceRoot, currentVehicle)
			VehicleSelect.exit()
		end, 1500, 1)
		fadeCamera(false, 1)
		return
	end
	if key == "arrow_r" then
		currentVehicle = currentVehicle - 1
	elseif key == "arrow_l" then
		currentVehicle = currentVehicle + 1
	end
	currentVehicle = math.min(#positions, currentVehicle)
	currentVehicle = math.max(1, currentVehicle)

	targetPosition = cameraPositions[currentVehicle]
	targetLookPosition = positions[currentVehicle]
end

function VehicleSelect.enter(models)
	if not models then
		return 
	end
	if isActive then
		return
	end
	for i, pos in ipairs(positions) do
		vehicles[i] = Vehicle(models[i], pos)
		vehicles[i].rotation = Vector3(0, 0, rotations[i])
		vehicles[i]:setData("bodykit", 1)
		vehicles[i]:setData("wheels", 3)
		--vehicles[i].frozen = true
	end
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientKey", root, onKey)
	exports.dpHUD:setVisible(false)
	isActive = true
	isSelected = false
	fadeCamera(true, 1)
	showChat(false)
	textures.car1 = dxCreateTexture("assets/test.png")
	textures.shadow = exports.dpAssets:createTexture("screen_shadow.png")
	setTime(12, 12)
end

function VehicleSelect.exit()
	if not isActive then
		return
	end
	isActive = false
	exports.dpHUD:setVisible(true)
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientKey", root, onKey)
	removeEventHandler("onClientRender", root, draw)
	fadeCamera(false, 1)
	for k, v in pairs(textures) do
		destroyElement(v)
	end
	textures = {}

	-- Удаление автомобилей
	for i, vehicle in ipairs(vehicles) do
		destroyElement(vehicle)
	end
	vehicles = {}	
	showChat(true)
end

addEvent("dpVehicleSelect.start", true)
addEventHandler("dpVehicleSelect.start", root, function(models)
	if not models then
		models = {411, 411, 411}
	end
	VehicleSelect.enter(models)
end)

if DEBUG_AUTOSTART then
	addEventHandler("onClientResourceStart", resourceRoot, function ()
		VehicleSelect.enter({411, 562, 411})
	end)
end