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

function getVehicleClass(nameOrId)
	if type(nameOrId) == "string" then
		return vehicleClasses[nameOrId]
	elseif type(nameOrId) == "number" then
		local name = getVehicleNameFromModel(model)
		if name then
			return vehicleClasses[name]
		end
	end
end

function getVehicleClassName(class)
	if not class then
		return false
	end
	return classNames[class]
end