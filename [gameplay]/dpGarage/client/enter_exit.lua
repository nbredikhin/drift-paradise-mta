-- Вход/выход в гараж

local ENABLE_GARAGE_CMD = true		-- Команда /garage для входа в гараж
local isEnterExitInProcess = false 	-- Входит (выходит) ли в данный момент игрок в гараж

addEvent("dpGarage.enter", true)
addEventHandler("dpGarage.enter", resourceRoot, function (success, errorType)
	isEnterExitInProcess = false
	fadeCamera(true)
	if success then
		Garage.start()
	else
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

local function enterExitGarage(enter)
	if isEnterExitInProcess then
		return false
	end
	isEnterExitInProcess = true
	fadeCamera(false, 1)
	Timer(function ()
		if enter then
			triggerServerEvent("dpGarage.enter", resourceRoot)
		else
			triggerServerEvent("dpGarage.exit", resourceRoot)
		end
	end, 1000, 1)
	return true
end

-- Функции для экспорта
function enterGarage()
	enterExitGarage(true)
end

function exitGarage()
	enterExitGarage(false)
end

if ENABLE_GARAGE_CMD then
	addCommandHandler("garage", function ()
		enterExitGarage(not Garage.isActive())
	end)
end