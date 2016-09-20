-- Классы
local vehicleClasses = {
	nissan_240sx = 1,
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