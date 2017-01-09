Carshop = {}
Carshop.isActive = false
Carshop.currentVehicleInfo = {}
Carshop.hasDriftHandling = false

local LOCAL_DIMENSION = 1
local CARSHOP_POSITION = Vector3(1230.2, -1788.7, 120.156)
local CARSHOP_ROTATION = 50
local VEHICLE_OFFSET = Vector3(0, 0, -2)
local STAGE_OFFSET = Vector3(0, 0, -3)

local vehiclesList = {}

local vehicle
local stageObject
local roomObject

-- Вращение подиума
local automoving = true
local automovingAcceleration = 0.6
local automovingSpeed = 7

local rotationSpeed = 0
local rotationPower = 100

local showTimer
local moveTimer

local currentVehicleId = 1

-- UI
local screenSize = Vector2(guiGetScreenSize())
local screenShadowTexture
local themeColor = {0, 0, 0}
local fonts = {}

local cameraScrollValue = 0
local isBuying = false

local function update(dt)
	dt = dt / 1000
	vehicle.rotation = vehicle.rotation + Vector3(0, 0, rotationSpeed) * dt
	stageObject.rotation = Vector3(0, 0, vehicle.rotation.z)

	if automoving then
		rotationSpeed = rotationSpeed + (automovingSpeed - rotationSpeed) * automovingAcceleration * dt
	else
		rotationSpeed = rotationSpeed * 0.95
	end
end

local function draw()
	-- Тень у краёв экрана
	dxDrawImage(0, 0, screenSize.x, screenSize.y, screenShadowTexture, 0, 0, 0, tocolor(0, 0, 0, 200))

	local primaryColor = tocolor(themeColor[1], themeColor[2], themeColor[3], 255)
	dxDrawText(
		"$#FFFFFF" .. tostring(localPlayer:getData("money")),
		0, 20,
		screenSize.x - 20, screenSize.y,
		primaryColor,
		1,
		fonts.money,
		"right",
		"top",
		false, false, false, true
	)

	dxDrawText(
		exports.dpLang:getString("player_level") .. ": #FFFFFF" .. tostring(localPlayer:getData("level")),
		0, 60,
		screenSize.x - 20, screenSize.y,
		primaryColor,
		1,
		fonts.level,
		"right",
		"top",
		false, false, false, true
	)
end

local function startAutomoving()
	automoving = true
end

local function onCursorMove(x, y)
	if isMTAWindowActive() or isCursorShowing() then
		return
	end
	local dx = x - 0.5
	rotationSpeed = rotationSpeed + dx * rotationPower
	automoving = false

	if isTimer(moveTimer) then
		killTimer(moveTimer)
	end
	moveTimer = setTimer(startAutomoving, 2000, 1)
end

local function onMouseWheel(key, state, delta)
	local targetCamera = CameraManager.getTargetCamera()

	cameraScrollValue = math.min(1, math.max(0, cameraScrollValue + delta * 0.25))

	targetCamera.FOV = 50 - cameraScrollValue * 10
	targetCamera.targetPosition = CARSHOP_POSITION + VEHICLE_OFFSET + Vector3(-1, 0, 1) * (1 - cameraScrollValue)
	targetCamera.distance = 16 - 5 * cameraScrollValue
	targetCamera.rotationVertical = 4 + cameraScrollValue * 4

	for doorId = 2, 5 do
		vehicle:setDoorOpenRatio(doorId, cameraScrollValue, 500)
	end
end

local function onKey(key, down)
	if not down or isBuying then
		return false
	end

	if exports.dpTutorialMessage:isMessageVisible() then
		return
	end

	if key == "a" or key == "arrow_l" then
		currentVehicleId = currentVehicleId - 1
		if currentVehicleId < 1 then
			currentVehicleId = #vehiclesList
		end
		Carshop.showVehicle(currentVehicleId)
		exports.dpUI:hideMessageBox()
		exports.dpSounds:playSound("ui_change.wav")
	elseif key == "d" or key == "arrow_r" then
		currentVehicleId = currentVehicleId + 1
		if currentVehicleId > #vehiclesList then
			currentVehicleId = 1
		end
		Carshop.showVehicle(currentVehicleId)
		exports.dpUI:hideMessageBox()
		exports.dpSounds:playSound("ui_change.wav")
	elseif key == "backspace" then
		if localPlayer:getData("tutorialActive") then
			return
		end
		if exports.dpUI:isMessageBoxVisible() then
			exports.dpUI:hideMessageBox()
		else
			exitCarshop()
		end
		exports.dpSounds:playSound("ui_back.wav")
	end
end

function Carshop.start()
	if Carshop.isActive then
		return false
	end
	Carshop.isActive = true
	isBuying = false

	-- Список автомобилей
	vehiclesList = {}
	local vehicles = exports.dpShared:getVehiclesTable()
	for name, model in pairs(vehicles) do
		local priceInfo = exports.dpShared:getVehiclePrices(name)
		if priceInfo then
			local vehicleInfo = {
				model = model,
				name = exports.dpShared:getVehicleReadableName(name),
				price = priceInfo[1],
				level = priceInfo[2],
				premium = priceInfo[3],
				specs = {
					speed = (3 + math.random(1, 7)) / 10,
					acceleration = (3 + math.random(1, 7)) / 10,
					control = (3 + math.random(1, 7)) / 10
				}
			}
			table.insert(vehiclesList, vehicleInfo)
		end
	end

	table.sort(vehiclesList, function (v1, v2)
		if not v1.premium and v2.premium then
			return true
		else
			return false
		end
	end)

	localPlayer.dimension = LOCAL_DIMENSION

	-- Создать автомобиль
	vehicle = createVehicle(411, CARSHOP_POSITION + VEHICLE_OFFSET)
	vehicle.frozen = true
	vehicle.alpha = 0
	vehicle.dimension = LOCAL_DIMENSION
	vehicle:setData("Numberplate", "CREW")

	toggleAllControls(false)
	exports.dpHUD:setVisible(false)
	exports.dpChat:setVisible(false)

	addEventHandler("onClientCursorMove", root, onCursorMove)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientKey", root, onKey)

	bindKey("mouse_wheel_up", "down" , onMouseWheel, 1)
	bindKey("mouse_wheel_down", "down" , onMouseWheel, -1)
	bindKey("enter", "down", Carshop.buy)

	-- UI
	screenShadowTexture = exports.dpAssets:createTexture("screen_shadow.png")
	themeColor = {exports.dpUI:getThemeColor()}
	fonts.money = exports.dpAssets:createFont("Roboto-Regular.ttf", 24)
	fonts.level = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)

	currentVehicleId = 1
	Carshop.showVehicle(currentVehicleId)
	CarshopMenu.start(CARSHOP_POSITION)
	CameraManager.start()

	if localPlayer:getData("tutorialActive") then
		exports.dpTutorialMessage:showMessage(
			exports.dpLang:getString("tutorial_car_shop_title"),
			exports.dpLang:getString("tutorial_car_shop_text"),
			"$" .. tostring(localPlayer:getData("money")),
			utf8.lower(exports.dpLang:getString("controls_arrows")),
			utf8.lower(exports.dpLang:getString("controls_mouse")),
			"ENTER")
	end
end

function Carshop.stop()
	if not Carshop.isActive then
		return false
	end
	Carshop.isActive = false

	if isElement(vehicle) then
		destroyElement(vehicle)
	end
	for name, font in pairs(fonts) do
		if isElement(font) then
			destroyElement(font)
		end
	end
	fonts = {}

	toggleAllControls(true)
	exports.dpHUD:setVisible(true)
	exports.dpChat:setVisible(true)

	if isElement(screenShadowTexture) then
		destroyElement(screenShadowTexture)
	end

	removeEventHandler("onClientCursorMove", root, onCursorMove)
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientKey", root, onKey)

	unbindKey("mouse_wheel_up", "down" , onMouseWheel, 1)
	unbindKey("mouse_wheel_down", "down" , onMouseWheel, -1)
	unbindKey("enter", "down", Carshop.buy)

	CarshopMenu.stop()
	CameraManager.stop()
end

function Carshop.getVehicle()
	return vehicle
end

function Carshop.showVehicle(id)
	local vehicleInfo = vehiclesList[id]
	if not vehicleInfo then
		outputDebugString("No info for vehicle: " .. tostring(id))
		return false
	end
	Carshop.currentVehicleInfo = vehicleInfo

	vehicle.model = vehicleInfo.model
	vehicle.frozen = false
	vehicle.alpha = 0
	vehicle.position = CARSHOP_POSITION + VEHICLE_OFFSET

	if isTimer(showTimer) then
		killTimer(showTimer)
	end
	showTimer = setTimer(function ()
		vehicle.alpha = 255
		local color = exports.dpShared:getGameplaySetting("default_vehicle_color") or {255, 255, 255}
		vehicle:setColor(unpack(color))
	end, 250, 1)

	local vehicleName = exports.dpShared:getVehicleNameFromModel(vehicle.model)
	Carshop.hasDriftHandling = exports.dpVehicles:hasVehicleHandling(vehicleName, "drift", 1)
end

function Carshop.buy()
	if exports.dpTutorialMessage:isMessageVisible() then
		return
	end
	if Carshop.currentVehicleInfo.premium and not localPlayer:getData("isPremium") then
		exports.dpSounds:playSound("error.wav")
		return
	end
	if not hasMoreGarageSlots() then
		exports.dpSounds:playSound("error.wav")
		return
	end
	if Carshop.currentVehicleInfo.level > localPlayer:getData("level") then
		exports.dpSounds:playSound("error.wav")
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("carshop_buy_error_title"),
			string.format(
				exports.dpLang:getString("carshop_required_level"),
				tostring(Carshop.currentVehicleInfo.level)))
	elseif Carshop.currentVehicleInfo.price > localPlayer:getData("money") then
		exports.dpSounds:playSound("error.wav")
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("carshop_buy_error_title"),
			exports.dpLang:getString("carshop_no_money"))
	else
		triggerServerEvent("dpCarshop.buyVehicle", resourceRoot, Carshop.currentVehicleInfo.model)
		isBuying = true
		exports.dpSounds:playSound("sell.wav")
	end
	exports.dpSounds:playSound("ui_select.wav")
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Замена моделей
	local txd = engineLoadTXD("assets/object.txd")
	engineImportTXD(txd, 3781)
	engineImportTXD(txd, 3782)
	local dff = engineLoadDFF("assets/object.dff")
	engineReplaceModel(dff, 3781)
	dff = engineLoadDFF("assets/object2.dff")
	engineReplaceModel(dff, 3782)
	local col = engineLoadCOL("assets/object2.col")
	engineReplaceCOL(col, 3782)

	-- Создание объектов помещения
	stageObject = createObject(3782, CARSHOP_POSITION + STAGE_OFFSET)
	roomObject = createObject(3781, CARSHOP_POSITION, 0, 0, CARSHOP_ROTATION)
	stageObject.dimension = LOCAL_DIMENSION
	roomObject.dimension = LOCAL_DIMENSION
end)

function hasMoreGarageSlots()
    local garageSlots = exports.dpShared:getGameplaySetting("default_garage_slots")
    if localPlayer:getData("isPremium") then
        garageSlots = exports.dpShared:getGameplaySetting("premium_garage_slots")
    end
	if localPlayer:getData("garage_cars_count") >= garageSlots then
		return false
	end
	return true
end

addEvent("dpCarshop.buyVehicle", true)
addEventHandler("dpCarshop.buyVehicle", resourceRoot, function (success)
	isBuying = false
	
	if not success then
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("carshop_buy_error_title"),
			exports.dpLang:getString("carshop_buy_error_unknown"))
		return
	else
		exitCarshop(true)
	end
end)
