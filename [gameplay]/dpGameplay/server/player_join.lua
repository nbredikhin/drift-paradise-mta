-- Вход игрока на сервер

addEvent("dpAccounts.login", false)
addEventHandler("dpAccounts.login", root, function (success)
	if not success then
		return
	end
	
	exports.dpPlayers:spawnPlayer(source)
end)