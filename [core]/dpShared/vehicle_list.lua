-- Краткие названия для использования в коде вместо ID
local vehiclesTable = {
	bmw_e46 = 436,
	lamborghini_huracan = 415,
	mazda_mx5miata = 411,
	nissan_240sx = 602,
	nissan_er34 = 445,
	nissan_gtr = 558,
	toyota_ae86 = 589,
}

-- Названия в том виде, в котором они будут отображаться
local vehiclesReadableNames = {
	bmw_e46 = "BMW E46",
	lamborghini_huracan = "Lamborghini Huracan",
	mazda_mx5miata = "Mazda MX-5",
	nissan_240sx = "Nissan 240SX",
	nissan_er34 = "Nissan Skyline ER34",
	nissan_gtr = "Nissan GT-R",
	toyota_ae86 = "Toyota AE86",
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