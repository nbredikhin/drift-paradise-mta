local gameplaySettings = {
	
}

function getGameplaySetting(name)
	if not name then
		return
	end
	return gameplaySettings[name]
end