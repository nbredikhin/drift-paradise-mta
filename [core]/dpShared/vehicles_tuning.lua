local tuningTable = {}

function getVehicleTuningTable(name)
	if name and tuningTable[name] then
		return tuningTable[name]
	else
		outputDebugString(string.format("Warning: no tuning table for \"%s\"", tostring(name)))
		return tuningTable.default
	end
end

-- Настройки по умолчанию
-- используются, если для автомобиля не прописаны настройки

-- {Цена, Уровень, [Донат-валюта]}
tuningTable.default = {
	-- Стоковые компоненты всегда бесплатные
	components = {
		FrontBump 	= {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
		RearBump 	= {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
		SideSkirts 	= {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
		Spoilers 	= {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
		FrontFends 	= {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
		RearFends 	= {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
		Bonnets		= {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
		RearLights 	= {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
		Exhaust 	= {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
	}
}