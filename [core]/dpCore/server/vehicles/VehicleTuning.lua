VehicleTuning = {}
local REMOVE_ZERO_FIELDS = true

VehicleTuning.defaultTuningTable = {
	BodyColor 		= {255, 0, 0},		-- Цвет кузова
	WheelsColor 	= {255, 255, 255},	-- Цвет дисков
	BodyTexture 	= false,			-- Текстура кузова
	NeonColor 		= false,			-- Цвет неона
	SpoilerColor	= false,			-- Цвет спойлера
	Numberplate 	= "DRIFT", 			-- Текст номерного знака
	Nitro 			= 0, -- Уровень нитро
	Windows			= 0, -- Тонировка окон	
	WheelsAngleF 	= 0, -- Развал передних колёс
	WheelsAngleR 	= 0, -- Развал задних колёс
	WheelsOffsetF	= 0, -- Вынос передних колёс
	WheelsOffsetR	= 0, -- Вынос задних колёс
	Suspension 		= 0, -- Высота подвески

	Wheels 			= 0, -- Колёса
	Spoilers 		= 0, -- Спойлер	
	FrontBump		= 0, -- Задний бампер
	RearBump		= 0, -- Передний бампер
	SideSkirts		= 0, -- Юбки
	Bonnets			= 0, -- Капот
	RearLights		= 0, -- Задние фары
	FrontFends		= 0, -- Передние фендеры
	RearFends		= 0, -- Задние фендеры
	Exhaust			= 0, -- Глушитель
	Acces			= 0, -- Аксессуары
}

function VehicleTuning.applyToVehicle(vehicle, tuningJSON, stickersJSON)
	if not isElement(vehicle) then
		return false
	end

	-- Тюнинг
	pcall(function ()
		local tuningTable
		if type(tuningJSON) == "string" then
			tuningTable = fromJSON(tuningJSON)
		end
		if not tuningTable then
			tuningTable = {}
		end
		-- Выставление полей по-умолчанию
		for k, v in pairs(VehicleTuning.defaultTuningTable) do
			if not tuningTable[k] then
				tuningTable[k] = v
			end
		end
		-- Перенос тюнинга в дату
		for k, v in pairs(tuningTable) do
			vehicle:setData(k, v)
		end
	end)

	-- Наклейки
	pcall(function ()
		local stickersTable
		if type(stickersJSON) == "string" then
			stickersTable = fromJSON(stickersJSON)
		end
		if not stickersTable then
			stickersTable = {}
		end
		vehicle:setData("stickers", stickersTable)
	end)
end

function VehicleTuning.updateVehicleTuning(vehicleId, tuning, stickers)
	if not vehicleId then
		return false
	end
	if type(tuning) ~= "table" or type(stickers) ~= "table" then
		return false
	end

	-- Удаление нулевых полей
	if REMOVE_ZERO_FIELDS then
		for k, v in pairs(tuning) do
			if not v or tonumber(v) == 0 then
				tuning[k] = nil
			end
		end
	end
	local tuningJSON = toJSON(tuning)
	if not tuningJSON then
		tuningJSON = nil
	end

	local stickersJSON = toJSON(stickers)
	if not stickersJSON then
		stickersJSON = nil
	end

	return UserVehicles.updateVehicle(vehicleId, { tuning = tuningJSON, stickers = stickersJSON })
end