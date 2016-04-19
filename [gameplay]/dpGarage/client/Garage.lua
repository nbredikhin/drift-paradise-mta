Garage = {}
Garage.active = false

local function enterGarage()
	if Garage.active then
		return false
	end
	Garage.active = true
	-- Вход в тюнинг
	GarageVehicle.start()
	GarageUI.start()
	fadeCamera(true)
	outputDebugString("enterGarage")
	return true
end

local function exitGarage()
	if not Garage.active then
		return false
	end
	Garage.active = false
	-- Выход из тюнинга
	GarageVehicle.stop()
	GarageUI.stop()
	fadeCamera(true)
	outputDebugString("exitGarage")
	return true
end

function Garage.enter()
	if Garage.active then
		return false
	end
	triggerServerEvent("dpGarage.clientEnter", resourceRoot)
	return true
end

function Garage.exit()
	if not Garage.active then
		return false
	end
	triggerServerEvent("dpGarage.clientExit", resourceRoot)
	return true
end

addEvent("dpGarage.serverEnter", true)
addEventHandler("dpGarage.serverEnter", resourceRoot, function (success) 
	if Garage.active then
		return false
	end	
	if not success then
		return
	end
	fadeCamera(false)
	setTimer(enterGarage, 1000, 1)
end)

addEvent("dpGarage.serverExit", true)
addEventHandler("dpGarage.serverExit", resourceRoot, function () 
	if not Garage.active then
		return false
	end	
	fadeCamera(false)
	setTimer(exitGarage, 1000, 1)
end)

addCommandHandler("garage", function ()
	if Garage.active then
		Garage.exit()
	else
		Garage.enter()
	end
end)