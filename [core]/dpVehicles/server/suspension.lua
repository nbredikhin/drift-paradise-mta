local MIN_SUSPENSION_DEFAULT = 0.04
local MAX_SUSPENSION_DEFAULT = 0.21

local overrideSuspension = {
	toyota_ae86 		= {0.02, 0.2},
	nissan_skyline2000 	= {0.04, 0.2},
	honda_civic 		= {0.03, 0.18},
	nissan_180sx 		= {0.06, 0.27},
	nissan_silvia_s13	= {0.05, 0.2},
	bmw_e30				= {0.05, 0.25},
	nissan_datsun_240z	= {0.08, 0.27},
	lamborghini_huracan	= {0.07, 0.27},
	ferrari_458_italia	= {0.07, 0.2},
	lamborghini_aventador = {0.08, 0.25},
}

function updateVehicleSuspension(vehicle)
	-- if not isElement(vehicle) then
	-- 	return false
	-- end
	-- local value = vehicle:getData("Suspension")
	-- if type(value) ~= "number" then
	-- 	value = getOriginalHandling(vehicle.model).suspensionLowerLimit
	-- else
	-- 	local minSuspension = MIN_SUSPENSION_DEFAULT
	-- 	local maxSuspension = MAX_SUSPENSION_DEFAULT
	-- 	local vehicleName = exports.dpShared:getVehicleNameFromModel(vehicle.model)
	-- 	if vehicleName and overrideSuspension[vehicleName] then
	-- 		minSuspension = overrideSuspension[vehicleName][1]
	-- 		maxSuspension = overrideSuspension[vehicleName][2]
	-- 	end
	-- 	value = -minSuspension - value * (maxSuspension - minSuspension)
	-- end
	-- setVehicleHandling(vehicle, "suspensionLowerLimit", value)
end