Tuning = {}
Tuning.active = false

local function enterTuning()
	if Tuning.active then
		return false
	end
	Tuning.active = true
	-- Вход в тюнинг
	TuningGarage.start()
	TuningUI.start()
	fadeCamera(true)
	outputDebugString("enterTuning")
	return true
end

local function exitTuning()
	if not Tuning.active then
		return false
	end
	Tuning.active = false
	-- Выход из тюнинга
	TuningGarage.stop()
	TuningUI.stop()
	fadeCamera(true)
	outputDebugString("exitTuning")
	return true
end

function Tuning.enter()
	if Tuning.active then
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
addEventHandler("dpTuning.serverEnter", resourceRoot, function (success) 
	if Tuning.active then
		return false
	end	
	if not success then
		return
	end
	fadeCamera(false)
	setTimer(enterTuning, 1000, 1)
end)

addEvent("dpTuning.serverExit", true)
addEventHandler("dpTuning.serverExit", resourceRoot, function () 
	if not Tuning.active then
		return false
	end	
	fadeCamera(false)
	setTimer(exitTuning, 1000, 1)
end)

addCommandHandler("tuning", function ()
	if Tuning.active then
		Tuning.exit()
	else
		Tuning.enter()
	end
end)