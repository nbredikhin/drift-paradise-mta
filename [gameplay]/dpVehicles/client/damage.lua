local function repairVehicle(vehicle)
	-- Восстановить hp
	vehicle.health = 1000
	-- Починить фары
	for i = 0, 3 do
		setVehicleLightState(vehicle, i, 0)
	end
	-- Починить двери
	for i = 0, 5 do
		setVehicleDoorState(vehicle, i, 0)
	end
	-- Починить хзчто
	fixVehicle(vehicle)
end

-- Отключение повреждений автомобилей

addEventHandler("onClientVehicleDamage", root, function ()
	cancelEvent()
	source:fix()
	repairVehicle(source)
end)

-- Переворот автомобиля на колёса
setTimer(function ()
	if not localPlayer.vehicle then
		return
	end
	if localPlayer.vehicle.health < 1000 then
		if localPlayer.vehicle.onGround then
			localPlayer.vehicle.rotation = Vector3(0, 0, localPlayer.vehicle.rotation.z)
		end
		repairVehicle(localPlayer.vehicle)
	end
end, 300, 0)