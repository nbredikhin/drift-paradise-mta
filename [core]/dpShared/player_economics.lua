local playerEconomics = {
	-- Начальные деньги
	start_money = 3000,
	-- Стартовые автомобили
	start_vehicles = {
		"nissan_240sx", 
		"toyota_ae86", 
		"mazda_mx5miata"
	}
}

function getEconomicsProperty(name)
	if not name then
		return
	end
	return playerEconomics[name]
end