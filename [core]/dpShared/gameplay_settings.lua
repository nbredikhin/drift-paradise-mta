local gameplaySettings = {
	start_vehicle = "toyota_ae86",
    default_vehicle_color = {255, 255, 255},

    default_garage_slots = 3,
    premium_garage_slots = 10,

    garage_slots_levels = {2, 5}
}

function getGameplaySetting(name)
	if not name then
		return
	end
	return gameplaySettings[name]
end