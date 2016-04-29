-- Выбор автомобиля

GarageCar = {}
local CAR_POSITION = Vector3 { x = 2915.438, y = -3186.282, z = 2535.244 }
local vehicle

function GarageCar.start()
	vehicle = createVehicle(411, CAR_POSITION)
	setTimer(function ()
		vehicle.frozen = true
	end, 1000, 1)
	vehicle.rotation = Vector3(0, 0, -90)
end

function GarageCar.stop()
	if isElement(vehicle) then
		destroyElement(vehicle)
	end
end

function GarageCar.getVehicle()
	return vehicle
end