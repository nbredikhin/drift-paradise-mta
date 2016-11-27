-- {цена, уровень, донат-валюта}
local vehiclesPrices = {
	-- 1 класс
	toyota_ae86 			= {7000,	1},
	nissan_skyline2000		= {9500,	1},
	honda_civic				= {10300,	1},
	-- 2 класс
	-- mazda_mx5miata 			= {18700,	5},
	nissan_180sx 			= {24600,	6},
	-- mitsubishi_eclipse		= {28300,	7},
	nissan_silvia_s13		= {32700,	9},
	-- 3 класс
	bmw_e30					= {45800,	22},
	-- nissan_skyline_er34 	= {41500,	17},
	-- toyota_mark2_100		= {45000,	20},
	nissan_datsun_240z		= {36300,	14},
	-- toyota_altezza			= {47000,	24},
	-- 4 класс
	-- honda_s2000 			= {48400,	28},
	bmw_e34 				= {49150,	32},
	nissan_silvia_s14		= {53600,	37},
	-- nissan_silvia_s15		= {59300,	44},
	mazda_rx8				= {62000,	48},
	-- 5 класс
	bmw_e60					= {64000,	53},
	-- toyota_supra			= {81550,	58},
	bmw_e46 				= {87400,	64},
	nissan_skyline_gtr34 	= {94100,	72},
	-- subaru_brz 				= {98000,	78},
	-- 6 класс
	nissan_gtr35 			= {125000,	85},
	lamborghini_huracan 	= {203000,	91},
	ferrari_458_italia		= {215000,	94},
	lamborghini_aventador 	= {390000,	100}
}

function getVehiclePrices(name)
	if name then
		return vehiclesPrices[name]
	end
end