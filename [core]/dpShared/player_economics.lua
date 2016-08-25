local playerEconomics = {
	-- Начальные деньги
	start_money = 3000,
	-- Стартовые автомобили
	start_vehicles = {
		"nissan_240sx", 
		"toyota_ae86", 
		"mazda_mx5miata"
	},

	-- Дуэли
	duel_bet_min = 500,
	duel_bet_max = 5000
}

function getEconomicsProperty(name)
	if not name then
		return
	end
	return playerEconomics[name]
end