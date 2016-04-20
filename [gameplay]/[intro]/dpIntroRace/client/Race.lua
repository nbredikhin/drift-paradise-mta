Race = {}

local playerVehiclePosition = Vector3 { x = 1953.827, y = -1138.4, z = 25.382 } 
local botVehiclePosition = Vector3 { x = 1953.827, y = -1133.4, z = 25.382 } 
local playerVehicle
local botVehicle
local botPed

function Race.create()
	playerVehicle = Vehicle(411, playerVehiclePosition, 0, 0, 270)
	botVehicle = Vehicle(411, botVehiclePosition, 0, 0, 270)
	botPed = Ped(0, 0, 0, 0)
	botPed:warpIntoVehicle(botVehicle)
	--localPlayer:warpIntoVehicle(playerVehicle)
end

function Race.stop()
	destroyElement(playerVehicle)
	destroyElement(botVehicle)
	destroyElement(botPed)
end