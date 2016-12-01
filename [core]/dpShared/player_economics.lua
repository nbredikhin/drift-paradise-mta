local playerEconomics = {
	-- Начальные деньги
	start_money = 11000,

	-- Дуэли
	duel_bet_min = 50,
	duel_bet_max = 500,

	-- Количество денег за 100000 очков дрифта
	drift_money = 450,
	-- Количество опыта за 100000 очков дрифта
	drift_xp = 275,

	-- Процент от цены авто при продаже
	vehicle_sell_price = 0.35,

	race_prizes = {
		{ xp = 350, money = 700 },
		{ xp = 300, money = 500 },
		{ xp = 250, money = 300 },
		{ xp = 200, money = 150 },
		{ xp = 150, money = 75 },
	},

	tofu_prize = 500,
	tofu_xp = 300,
	tofu_perfect_mul = 1.1,
}

function getEconomicsProperty(name)
	if not name then
		return
	end
	return playerEconomics[name]
end