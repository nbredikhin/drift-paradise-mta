-- Вход/выход в гараж

local ENABLE_GARAGE_CMD = true		-- Команда /garage для входа в гараж
local isEnterExitInProcess = false 	-- Входит (выходит) ли в данный момент игрок в гараж

addEvent("dpGarage.enter", true)
addEventHandler("dpGarage.enter", resourceRoot, function (success, vehiclesList, enteredVehicleId, vehicle)
	isEnterExitInProcess = false
	
	if success then
		Garage.start(vehiclesList, enteredVehicleId, vehicle)
	else
		local errorType = vehiclesList
		fadeCamera(true, 0.5)
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
	setTimer(function ()
		fadeCamera(true, 0.5)
	end, 500, 1)	
end)

local function enterExitGarage(enter, selectedCarId)
	if isEnterExitInProcess then
		return false
	end
	isEnterExitInProcess = true
	fadeCamera(false, 0.5)
	Timer(function ()
		if enter then
			triggerServerEvent("dpGarage.enter", resourceRoot)
		else
			triggerServerEvent("dpGarage.exit", resourceRoot, selectedCarId)
		end
	end, 500, 1)
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