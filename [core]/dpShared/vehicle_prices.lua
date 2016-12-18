-- {цена, уровень, донат-валюта}
local vehiclesPrices = {
	-- 1 класс
	toyota_ae86 			= {8000,	1},
	nissan_skyline2000		= {9500,	1},
	honda_civic				= {10300,	1},
	-- 2 класс
	mazda_mx5miata 			= {22000,	5},
	nissan_180sx 			= {28000,	7},
	mitsubishi_eclipse		= {28300,	9},
	nissan_silvia_s13		= {32700,	11},
	-- 3 класс
	nissan_datsun_240z		= {41500,	13},
	nissan_skyline_er34 	= {48000,	15},
	toyota_mark2_100		= {55000,	17},
	bmw_e30					= {62000,	19},
	toyota_altezza			= {68500,	21},
	-- 4 класс
	honda_s2000 			= {78200,	25},
	bmw_e34 				= {84000,	29},
	nissan_silvia_s14		= {92100,	34},
	nissan_silvia_s15		= {100000,	37},
	-- mazda_rx8				= {62000,	48},
	-- 5 класс
	bmw_e60					= {120000,	42},
	toyota_supra			= {140000,	45},
	bmw_e46 				= {165000,	49},
	nissan_skyline_gtr34 	= {183500,	55},
	subaru_brz 				= {196000,	59},
	-- 6 класс
	nissan_gtr35 			= {310000,	64},
	lamborghini_huracan 	= {350000,	67},
	ferrari_458_italia		= {385500,	73},
	lamborghini_aventador 	= {430000,	80}
}

function getVehiclePrices(name)
	if name then
		return vehiclesPrices[name]
	end
end
