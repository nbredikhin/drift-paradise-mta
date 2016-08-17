-- {цена, уровень, донат-валюта}
local vehiclesPrices = {
	nissan_240sx 	= {40000, 5},
	nissan_gtr 		= {70000, 25},
	toyota_ae86 	= {20000, 1},
	mazda_mx5miata 	= {30000, 1}
}

function getVehiclePrices(name)
	if name then
		return vehiclesPrices[name]
	end
end