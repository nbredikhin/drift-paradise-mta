local myVehicleMenu = {
	{ text = "Заглушить двигатель" }, 
	{ text = "Включить фары" }, 
	{ text = "Открыть переднюю левую дверь" },
	{ text = "Открыть переднюю правую дверь" },
	{ text = "Открыть заднюю левую дверь", enabled = false},
	{ text = "Открыть заднюю правую дверь", enabled = false},	
}

local otherVehicleMenu = {
	{ text = "Посмотреть профиль", enabled = false},
	{ text = "Вызвать на гонку", enabled = false},
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