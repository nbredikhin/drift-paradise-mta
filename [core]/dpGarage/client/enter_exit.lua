-- Вход/выход в гараж

local ENABLE_GARAGE_CMD = true		-- Команда /garage для входа в гараж
local isEnterExitInProcess = false 	-- Входит (выходит) ли в данный момент игрок в гараж

local screenSize = Vector2(guiGetScreenSize())

local function drawLoadingScreen(callback)
	if type(callback) ~= "function" then
		return
	end
	
	local fading = 0
	local fadingTime = 0.3
	local logoTexture = exports.dpAssets:createTexture("logo_square.png")
	local logoSize = 420
	local function draw()
		dxDrawImage(
			screenSize.x / 2 - logoSize / 2, 
			screenSize.y / 2 - logoSize / 2, 
			logoSize, logoSize, 
			logoTexture, 0, 0, 0, 
			tocolor(255, 255, 255, 255 * fading)
		)
	end
	local function update(dt)
		fading = fading + dt / 1000 * (1 / fadingTime)
		if fading > 1 then
			fading = 1
		end
	end
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientPreRender", root, update)

	setTimer(function()
		callback()
		destroyElement(logoTexture)
		removeEventHandler("onClientRender", root, draw)
		removeEventHandler("onClientPreRender", root, update)
	end, 1000, 1)
end

addEvent("dpGarage.enter", true)
addEventHandler("dpGarage.enter", resourceRoot, function (success, vehiclesList, enteredVehicleId, vehicle)
	isEnterExitInProcess = false
	
	if success then
		drawLoadingScreen(function ()
			Garage.start(vehiclesList, enteredVehicleId, vehicle)
		end)
	else
		local errorType = vehiclesList
		fadeCamera(true)
		if errorType then
			local errorText = exports.dpLang:getString(errorType)
			if errorText then
				outputChatBox(errorText, 255, 0, 0)
			end
		end
	end
end)

addEvent("dpGarage.exit", true)
addEventHandler("dpGarage.exit", resourceRoot, function (success)
	isEnterExitInProcess = false
	Garage.stop()
	fadeCamera(true)
end)

local function enterExitGarage(enter, selectedCarId)
	if isEnterExitInProcess then
		return false
	end
	isEnterExitInProcess = true
	fadeCamera(false, 1)
	Timer(function ()
		if enter then
			triggerServerEvent("dpGarage.enter", resourceRoot)
		else
			triggerServerEvent("dpGarage.exit", resourceRoot, selectedCarId)
		end
	end, 1000, 1)
	return true
end

-- Функции для экспорта
function enterGarage()
	enterExitGarage(true)
end

function exitGarage(selectedCarId)
	enterExitGarage(false, selectedCarId)
end

if ENABLE_GARAGE_CMD then
	addCommandHandler("garage", function ()
		enterExitGarage(not Garage.isActive())
	end)
end