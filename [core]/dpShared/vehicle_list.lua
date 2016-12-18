-- Краткие названия для использования в коде вместо ID
local vehiclesTable = {
	-- 1 класс
	toyota_ae86 		= 589,
	nissan_skyline2000	= 535,
	honda_civic			= 565,
	-- 2 класс
	-- mazda_mx5miata 		= 411,
	nissan_180sx 		= 602,
	-- mitsubishi_eclipse	= nil,
	nissan_silvia_s13	= 401,
	-- 3 класс
	bmw_e30				= 410,
	-- nissan_skyline_er34 = 445,
	-- toyota_mark2_100	= nil,
	nissan_datsun_240z	= 475,
	-- toyota_altezza 		= 402,
	-- 4 класс
	-- honda_s2000 		= 429,
	bmw_e34 			= 529,
	nissan_silvia_s14	= 576,
	-- nissan_silvia_s15	= nil,
	mazda_rx8 			= 550,
	-- 5 класс
	bmw_e60				= 540,
	-- toyota_supra		= nil,
	bmw_e46 			= 436,
	nissan_skyline_gtr34 = 562,
	-- subaru_brz 			= nil,
	-- 6 класс
	nissan_gtr35 		= 558,
	lamborghini_huracan = 415,
	ferrari_458_italia	= 451,
	lamborghini_aventador = 506
}

-- Названия в том виде, в котором они будут отображаться
local vehiclesReadableNames = {
	-- 1 класс
	toyota_ae86 		= "Toyota AE86",
	nissan_skyline2000	= "Nissan Skyline 2000",
	honda_civic			= "Honda Civic",
	-- 2 класс
	mazda_mx5miata 		= "Mazda MX5 Miata",
	nissan_180sx 		= "Nissan 180SX",
	mitsubishi_eclipse	= "Mitsubishi Eclipse",
	nissan_silvia_s13	= "Nissan Silvia S13",
	-- 3 класс
	bmw_e30				= "BMW E30",
	nissan_skyline_er34 = "Nissan Skyline ER34",
	toyota_mark2_100	= "Toyota Mark II 100",
	nissan_datsun_240z 	= "Nissan Datsun 240Z",
	toyota_altezza 		= "Toyota Altezza",
	-- 4 класс
	honda_s2000 		= "Honda S2000",
	bmw_e34 			= "BMW E34",
	nissan_silvia_s14	= "Nissan Silvia S14",
	nissan_silvia_s15	= "Nissan Silvia S15",
	mazda_rx8			= "Mazda RX-8",
	-- 5 класс
	bmw_e60				= "BMW E60",
	toyota_supra		= "Toyota Supra",
	bmw_e46 			= "BMW M3 E46",
	nissan_skyline_gtr34 = "Nissan Skyline GTR34",
	subaru_brz 			= "Subaru BRZ",
	-- 6 класс
	nissan_gtr35 		= "Nissan GTR35",
	lamborghini_huracan = "Lamborghini Huracan",
	ferrari_458_italia	= "Ferrari 458 Italia",
	lamborghini_aventador = "Lamborghini Aventador"
}

-- Функции

function getVehicleModelFromName(name)
	if not name then
		return false
	end
	return vehiclesTable[name]
end

function getVehicleNameFromModel(model)
	if type(model) ~= "number" then
		return false
	end
	for name, currentModel in pairs(vehiclesTable) do
		if currentModel == model then
			return name
		end
	end
end

function getVehiclesTable()
	return vehiclesTable
end

function getVehicleReadableName(nameOrId)
	if type(nameOrId) == "string" then
		return vehiclesReadableNames[nameOrId] or ""
	elseif type(nameOrId) == "number" then
		local name = getVehicleNameFromModel(nameOrId)
		if name then
			return vehiclesReadableNames[name] or ""
		end
	end
end
