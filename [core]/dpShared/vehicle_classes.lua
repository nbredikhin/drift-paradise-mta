-- Классы
local vehicleClasses = {
	toyota_ae86 			= 1,
	nissan_skyline2000		= 1,
	honda_civic				= 1,
	-- 2 класс
	mazda_mx5miata 			= 2,
	nissan_180sx 			= 2,
	mitsubishi_eclipse		= 2,
	nissan_silvia_s13		= 2,
	-- 3 класс
	bmw_e30					= 3,
	nissan_skyline_er34 	= 3,
	toyota_mark2_100		= 3,		
	toyota_altezza			= 3,
	-- 4 класс
	honda_s2000 			= 4,
	bmw_e34 				= 4,
	nissan_silvia_s14		= 4,
	nissan_silvia_s15		= 4,
	-- 5 класс
	bmw_e60					= 5,
	toyota_supra			= 5,
	bmw_m3_e46 				= 5,
	nissan_skyline_gtr34 	= 5,
	subaru_brz 				= 5,
	-- 6 класс
	nissan_gtr35 			= 6,
	lamborghini_huracan 	= 6,
	ferrari_458_italia		= 6,
	lamborghini_aventador 	= 6
}

-- Названия классов
local classNames = {
	"A1",
	"B2",
	"C3",
	"R4",
	"S5"
}

local function getVehicleClassFromName(name)
	if not name or not vehicleClasses[name]then
		return 1
	else 
		return vehicleClasses[name]
	end
end

function getVehicleClass(nameOrModel)
	if type(nameOrModel) == "string" then
		return getVehicleClassFromName(nameOrModel)
	elseif type(nameOrModel) == "number" then
		local name = getVehicleNameFromModel(nameOrModel)
		if name then
			return getVehicleClassFromName(name)
		end
	end
end

function getVehicleClassName(class)
	if not class then
		return false
	end
	return classNames[class]
end