addCommandHandler("unlockserver", function (player)
	if not exports.dpUtils:isPlayerAdmin(player) then
		outputChatBox("Вы не являетесь администратором", player, 255, 0, 0)
		return
	end
	-- Снять пароль с сервера
	setServerPassword(nil)

	local slots = 5
	setMaxPlayers(slots)
	setTimer(function()
		slots = slots + 1
		setMaxPlayers(slots)
	end, 1000, 195)
	outputChatBox("Запуск игроков на сервер...", root, 0, 255, 0)
end)