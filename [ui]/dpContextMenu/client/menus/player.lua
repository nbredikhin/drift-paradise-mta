local playerMenu = {
	title = "Игрок Wherry",
	items = {
		{ text = "Посмотреть профиль", enabled = false},
		{ text = "Вызвать на гонку", enabled = false},
		{ text = "Отправить PM", enabled = false},
		{ text = "Пожаловаться на игрока", enabled = false}	
	}
}

function playerMenu:init(player)
	if player == localPlayer then
		return false
	end	
	self.title = "Игрок " .. tostring(player.name)
end

registerContextMenu("player", playerMenu)