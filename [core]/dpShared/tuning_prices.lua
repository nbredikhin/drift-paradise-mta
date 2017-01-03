-- Цены на тюнинг
local tuningPrices = {
	-- Покраска кузова
	body_color = {0, 1},
	-- Смена номерного знака
	numberplate = {0, 1},
	-- Смена высоты подвески
	suspension = {0, 1},
	-- Спойлеры
	spoiler_color = {0, 1},
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
	wheels_size = {0, 1},
	wheels_advanced = {0, 1},	
	wheels_color = {0, 1},
	wheels = {
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
	exhausts = {
		{0, 1},
		{0, 1},
		{0, 1},
		{0, 1},
		{0, 1},
		{0, 1},
		{0, 1},
		{0, 1},
		{0, 1},
	},
	-- Улучшения
	upgrades_level = 1,
	upgrade_price_drift = 0,
	upgrade_price_street = 0,
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