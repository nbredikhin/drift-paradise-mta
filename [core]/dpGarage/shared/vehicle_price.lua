function getVehicleSellPrice(vehicleName, vehicleMileage)
    local priceTable = exports.dpShared:getVehiclePrices(vehicleName)
    if type(priceTable) ~= "table" or type(priceTable[1]) ~= "number" then
		return false
	end

    local minMileageFactor = exports.dpShared:getEconomicsProperty("vehicle_sell_min_mileage_factor")
    local maxMileage = exports.dpShared:getEconomicsProperty("vehicle_sell_max_mileage")
    local mileageFactor = minMileageFactor + (math.max(0, (maxMileage - vehicleMileage)) / maxMileage) * (1.0 - minMileageFactor)

    return math.floor(priceTable[1] * mileageFactor)
end
