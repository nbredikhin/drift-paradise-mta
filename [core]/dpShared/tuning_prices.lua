-- Цены на тюнинг
local tuningPrices = {
	-- Покраска кузова
	body_color = {500, 2},
	-- Смена номерного знака
	numberplate = {500, 5},
	-- Смена высоты подвески
	suspension = {1000, 3},
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
	wheels_size = {1000, 2},
	wheels_advanced = {1000, 1},	
	wheels_color = {800, 4},
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
		{0, 1},
		{0, 1}
	}
}

function getTuningPrices(name)
	if name then
		if tuningPrices[name] then
			return tuningPrices[name]
		else
			return {0, 1}
		end
	end
end