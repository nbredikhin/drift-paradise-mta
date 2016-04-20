Tuning = {}
Tuning.active = false 

function Tuning.start()
	if Tuning.active then
		return false
	end
	Tuning.active = true
	fadeCamera(true)	
	-- Запуск модулей
	TuningGarage.start()
	TuningUI.start()
	TuningCamera.start()
	return true
end

function Tuning.stop()
	if not Tuning.active then
		return false
	end
	Tuning.active = false
	fadeCamera(true)
	-- Останока всех модулей
	TuningGarage.stop()
	TuningUI.stop()	
	TuningCamera.stop()
	return true
end

function Tuning.enter()
	if Tuning.active then
		return false
	end
	-- Если игрок не в машине или игрок выходит из машины
	if not localPlayer.vehicle or localPlayer:getTask("primary", 3) == "TASK_COMPLEX_LEAVE_CAR" then		
		outputChatBox(exports.dpLang:getString("tuning_no_vehicle_error"), 255, 0, 0)
		return false
	end
	if localPlayer.vehicle.controller ~= localPlayer then
		outputChatBox(exports.dpLang:getString("tuning_not_driver"), 255, 0, 0)
		return false
	end
	if exports.dpUtils:getVehicleOccupantsCount(localPlayer.vehicle) > 1 then
		outputChatBox(exports.dpLang:getString("tuning_has_occupants"), 255, 0, 0)
		return false
	end
	triggerServerEvent("dpTuning.clientEnter", resourceRoot)
	return true
end

function Tuning.exit()
	if not Tuning.active then
		return false
	end
	triggerServerEvent("dpTuning.clientExit", resourceRoot)
	return true
end

addEvent("dpTuning.serverEnter", true)
addEventHandler("dpTuning.serverEnter", resourceRoot, function (success, errorName)
	if Tuning.active then
		return false
	end	
	if not success then
		local errorText = exports.dpLang:getString("tuning_enter_failed")
		if errorName then
			errorText = exports.dpLang:getString(errorName)			
		end
		outputChatBox(errorText, 255, 0, 0)
		return
	end
	fadeCamera(false)
	setTimer(Tuning.start, 1000, 1)
end)

addEvent("dpTuning.serverExit", true)
addEventHandler("dpTuning.serverExit", resourceRoot, function () 
	if not Tuning.active then
		return false
	end	
	fadeCamera(false)
	setTimer(Tuning.stop, 1000, 1)
end)

addCommandHandler("tuning", function ()
	if Tuning.active then
		Tuning.exit()
	else
		Tuning.enter()
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	if localPlayer:getData("state") == "tuning" then
		Tuning.active = true
		Tuning.exit()
	end
end)