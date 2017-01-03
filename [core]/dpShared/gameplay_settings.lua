local gameplaySettings = {
	start_vehicle = "toyota_ae86"
}

function getGameplaySetting(name)
	if not name then
		return
	end
	return gameplaySettings[name]
end