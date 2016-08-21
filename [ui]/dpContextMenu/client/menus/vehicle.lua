local myVehicleMenu = {
	{ text = "Заглушить двигатель (1)" },
	{ text = "Поставить на ручник (2)" },
	{ text = "Включить фары (3)" }, 
	{ text = "Открыть переднюю левую дверь" },
	{ text = "Открыть переднюю правую дверь" },
	{ text = "Открыть заднюю левую дверь", enabled = function(vehicle) 
		return vehicle:getComponentVisible("door_lb_dummy")
	end},
	{ text = "Открыть заднюю правую дверь", enabled = function(vehicle) 
		return vehicle:getComponentVisible("door_rb_dummy")
	end},	
}

local otherVehicleMenu = {
	{ text = "Посмотреть профиль", enabled = false},
	{ text = "Вызвать на гонку", enabled = true},
	{ text = "Отправить PM", enabled = false},
	{ text = "Пожаловаться на игрока", enabled = false}	
}

local vehicleMenu = {
	title = "Автомобиль",
	items = {}
}

function vehicleMenu:init(vehicle)
	if not vehicle.controller then
		return false
	end

	if vehicle.controller == localPlayer then
		self.items = myVehicleMenu
		self.title = "Автомобиль"
	else
		self.items = otherVehicleMenu
		self.title = "Автомобиль игрока " .. tostring(vehicle.controller.name)
	end
end

registerContextMenu("vehicle", vehicleMenu)