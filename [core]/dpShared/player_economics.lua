local playerEconomics = {
	-- Начальные деньги
	start_money = 11000,
	-- Стартовые автомобили
	start_vehicles = {
		"nissan_240sx", 
		"toyota_ae86", 
		"mazda_mx5miata"
	},

	-- Дуэли
	duel_bet_min = 50,
	duel_bet_max = 500,

	-- Количество денег за 100000 очков дрифта
	drift_money = 90,
	-- Количество опыта за 100000 очков дрифта
	drift_xp = 50,

	-- Процент от цены авто при продаже
	vehicle_sell_price = 0.35,
}

function getEconomicsProperty(name)
	if not name then
		return
	end
	return playerEconomics[name]
end