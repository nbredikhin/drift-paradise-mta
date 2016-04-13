-- Вход игрока на сервер

addEvent("dpAccounts.login", false)
addEventHandler("dpAccounts.login", root, function (success)
	if not success then
		return
	end
	
	-- Если не выбран персонаж - перекинуть на экран выбора персонажа
	exports.dpPlayers:spawnPlayer(source)
end)