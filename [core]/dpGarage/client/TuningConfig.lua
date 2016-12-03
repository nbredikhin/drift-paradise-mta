TuningConfig = {}

local tuningConfig = {}

-- Получение цены и уровня для компонента
function TuningConfig.getComponentConfig(model, name, id)
	-- price - цена
	-- level - уровень для покупки
	-- donatPrice - цена в донат-валюте (если false, то нельзя купить за донат-валюту)

	if not model or not name or not id or id <= 0 then
		return {price = 0, level = 1, donatPrice = false}
	end
	local vehicleName = exports.dpShared:getVehicleNameFromModel(model)
	local tuningTable = exports.dpShared:getVehicleTuningTable(vehicleName)

	local componentsList = tuningTable.components[name]
	if not componentsList then
		componentsList = {}
	end
	if name == "WheelsR" or name == "WheelsF" then
		componentsList = exports.dpShared:getTuningPrices("wheels")
	end
	if name == "Exhaust" then
		componentsList = exports.dpShared:getTuningPrices("exhausts")
	end
	if name == "Spoilers" then
		componentsList = {}
		if GarageCar.hasDefaultSpoilers() then
			local spoilersPrices = exports.dpShared:getTuningPrices("spoilers")
			for i, v in ipairs(spoilersPrices) do
				table.insert(componentsList, v)
			end
		end
		if tuningTable.components[name] then
			for i, v in ipairs(tuningTable.components[name]) do
				table.insert(componentsList, v)
			end
		end
	end

	if not componentsList[id] then
		return {price = 0, level = 1, donatPrice = false}
	else
		return {
			price = componentsList[id][1], 
			level = componentsList[id][2], 
			donatPrice = componentsList[id][3]
		}
	end
end

function TuningConfig.getComponentsCount(model, name)
	local vehicleName = exports.dpShared:getVehicleNameFromModel(model)
	local tuningTable = exports.dpShared:getVehicleTuningTable(vehicleName)

	local componentsList = tuningTable.components[name]
	if not componentsList then
		componentsList = {}
	end
	if name == "WheelsR" or name == "WheelsF" then
		componentsList = exports.dpShared:getTuningPrices("wheels")
	end
	if name == "Exhaust" then
		componentsList = exports.dpShared:getTuningPrices("exhausts")
	end	
	if name == "Spoilers" then
		componentsList = {}
		if GarageCar.hasDefaultSpoilers() then
			local spoilersPrices = exports.dpShared:getTuningPrices("spoilers")
			for i, v in ipairs(spoilersPrices) do
				table.insert(componentsList, v)
			end
		end
		if tuningTable.components[name] then
			for i, v in ipairs(tuningTable.components[name]) do
				table.insert(componentsList, v)
			end
		end
	end
	
	return #componentsList
end