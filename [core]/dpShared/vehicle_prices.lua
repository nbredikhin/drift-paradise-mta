-- {цена, уровень, донат-валюта}
local vehiclesPrices = {
	nissan_240sx 		= {0, 1},
	nissan_gtr 			= {0, 1},
	toyota_ae86 		= {0, 1},
	mazda_mx5miata 		= {0, 1},
	nissan_er34 		= {0, 1},
	bmw_dunno 			= {0, 1},
	lamborghini_huracan = {0, 1},
}

function getVehiclePrices(name)
	if name then
		return vehiclesPrices[name]
	end
end