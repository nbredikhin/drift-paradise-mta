-- Цены на тюнинг
local tuningPrices = {
	-- Покраска кузова
	body_color = {500, 2},
	-- Смена номерного знака
	numberplate = {100, 5},
	-- Смена высоты подвески
	suspension = {150, 4},
	-- Спойлеры
	spoiler_color = {650, 3},
	spoilers = {
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}, 
		{0, 1}
	},
	-- Колёса
	wheels_size = {100, 4},
	wheels_advanced = {150, 4},	
	wheels_color = {300, 10},
	wheels = {
		{300, 3},
		{500, 5},
		{750, 7},
		{860, 9},
		{940, 11},
		{1120, 13},
		{1250, 15},
		{1300, 17},
		{1350, 19},
		{1390, 21},
		{1430, 22},
		{1460, 23},
		{1500, 24},
		{1540, 26},
		{1590, 27},
		{1630, 29}
	},
	-- Улучшения
	upgrades_level = 4,
	upgrade_price_drift = 4000,
	upgrade_price_street = 2500,
}

function getTuningPrices(name)
	if name then
		if tuningPrices[name] then
			return tuningPrices[name]
		else
			return {999, 1}
		end
	end
end