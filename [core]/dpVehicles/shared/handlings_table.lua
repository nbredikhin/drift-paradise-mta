local handlingsTable = {}

-- Пример
-- handlingsTable["car_name"] = {
-- 	street = {
-- 		"стоковый хандлинг",
-- 		"стрит хандлинг"
-- 	},

-- 	drift = {
-- 		"дрифт хандлинг"
-- 	}
-- }

handlingsTable["toyota_ae86"] = {
	street = {
		"CLUB 11000 11000 0 0 0.1 -0.2 120 0.725 0.725 0.415 4 185 9.4 45 r p 4.3 0.5 false 22 1.5 1.5 0 0.28 -0.09 0.535 0 0.37 0 35000 40000004 C00200 1 1 0",
		"CLUB 11000 11000 0 0 0.1 -0.2 120 0.755 0.715 0.415 4 225 6.4 25 r p 4.3 0.5 false 22 1.5 1.5 0 0.28 -0.09 0.535 0 0.37 0 35000 40000004 C00200 1 1 0"
	},
	drift = {
		"CLUB 10450 15700 0 0 -0.18 -0.2 75 0.565 0.565 0.395 5 225 21.2 5 r p 12.4 0.001 false 50 1.5 1.5 0 0.28 -0.075 0.485 0 0.9 0 35000 40000800 300003 1 1 0"
	}
}

handlingsTable["mazda_mx5miata"] = {
	street = {
		"INFERNUS 11000 11000 0 0 0.1 -0.2 120 0.7 0.725 0.5 4 185 7.4 35 r p 4.3 0.5 false 20 1.5 1.5 0 0.28 -0.1 0.5 0 0.37 0 95000 40000004 C00200 1 1 1",
		"INFERNUS 11000 11000 0 0 0.1 -0.2 120 0.695 0.695 0.435 4 225 6.4 45 r p 4.4 0.5 false 22 1.5 1.5 0 0.28 -0.1 0.5 0 0.37 0 95000 40000004 C00200 1 1 1"
	},
	drift = {
		"INFERNUS 10450 14700 0 0 -0.18 -0.2 75 0.565 0.565 0.395 5 225 21.2 5 r p 12.4 0.001 false 50 1.5 1.5 0 0.28 -0.075 0.485 0 0.9 0 95000 40000800 300003 1 1 1"
	}
}

handlingsTable["nissan_180sx"] = {
	street = {
		"ALPHA 11000 11000 1 0 0.1 -0.2 85 0.75 0.8 0.5 4 215 6.6 20 r p 5 0.55 false 21 0.72 0.12 0 0.28 -0.18 0.53 0.4 0.9 0 35000 40000800 202200 1 1 0",
		"ALPHA 11000 11000 1 0 0.1 -0.2 85 0.765 0.795 0.435 4 225 8.9 105 r p 5.1 0.55 false 22 0.72 0.12 0 0.28 -0.17 0.53 0.4 0.9 0 35000 40000800 202200 1 1 0"
	},
	drift = {
		"ALPHA 10450 14500 0 0 -0.18 -0.2 75 0.575 0.575 0.368 5 245 22.2 -5 r p 12.4 0.001 false 50 1.5 1.5 0 0.28 -0.08 0.35 0 0.9 0 35000 40000800 300003 1 1 0"
	}
}

handlingsTable["nissan_skyline_er34"] = {
	street = {
		"ADMIRAL 11000 11000 0 0 0 0 120 0.655 0.825 0.435 4 225 6.9 40 r p 4.5 0.5 false 22 1.5 1.5 0 0.28 -0.029 0.455 0 0.78 0 35000 0 402200 0 1 0",
		"ADMIRAL 11000 11000 0 0 0 0 120 0.675 0.725 0.485 4 245 7.9 65 r p 4.5 0.5 false 22 1.5 1.5 0 0.28 -0.029 0.455 0 0.78 0 35000 0 402200 0 1 0"
	},
	drift = {
		"ADMIRAL 10450 17500 0 0 -0.18 -0.2 75 0.575 0.575 0.385 5 245 25.2 -5 r p 120.4 0.001 false 50 1.5 1.5 0 0.28 -0.04 0.4 0 0.9 0 35000 40800800 302203 0 1 0"
	}
}

handlingsTable["bmw_m3_e46"] = {
	street = {
		"PREVION 11000 11000 0 0 0 0 120 0.725 0.725 0.5 4 250 33.6 175 r p 4.2 0.5 false 22 1.5 1.5 0 0.25 -0.045 0.395 0 0.75 0 9000 2000 0 0 0 0",
		"PREVION 11000 11000 0 0 0.1 -0.2 120 0.725 0.725 0.5 4 265 13.9 115 r p 4.3 0.5 false 22 1.5 1.5 0 0.28 -0.054 0.345 0 0.37 0 9000 40002004 0 0 0 0"
	},
	drift = {
		"PREVION 11000 15500 5.455 0 0.1 -0.2 120 0.625 0.625 0.385 4 265 68.435 -17.9 r p 14.245 0.025 false 55 1.7 2.355 5.455 0.28 -0.045 0.365 0 0.75 0 9000 2000 F00003 0 0 0"
	}
}

handlingsTable["nissan_gtr35"] = {
	street = {
		"URANUS 11000 11000 0 0 0.1 -0.2 120 0.725 0.725 0.455 5 320 20.1 85 4 p 4.9 0.5 false 22 1.7 0.15 0 0.28 -0.1 0.5 0 1 0 35000 C0002800 4B00003 1 1 0",
		"URANUS 11000 11000 0 0 0.1 -0.2 120 0.725 0.725 0.495 5 320 20.1 75 4 p 4.9 0.5 false 22 1.7 0.15 0 0.28 -0.1 0.5 0 1 0 35000 C0002800 4B00003 1 1 0"
	},
	drift = {
		"URANUS 11000 15150 5.545 0 0.1 -0.2 120 0.645 0.635 0.395 5 320 70.3 -14.5 r p 12.145 0.025 false 55 1.7 2.15 5.545 0.28 -0.1 0.5 0 1 0 35000 C0002800 4B04403 1 1 0"
	}
}

handlingsTable["lamborghini_huracan"] = {
	street = {
		"CHEETAH 11000 11000 0 0 -0.2 -0.2 70 0.945 0.945 0.5 4 350 39.9 225 4 p 7.4 0.5 false 22 0.8 0.2 0 0.1 -0.05 0.6 0.6 0.4 0 105000 C0002004 204400 0 0 1",
		"CHEETAH 11000 11000 0 0 -0.2 -0.2 70 0.945 0.945 0.5 4 350 39.9 175 4 p 8.5 0.5 false 22 0.8 0.2 0 0.1 -0.05 0.6 0.6 0.4 0 105000 C0002004 208800 0 0 1"
	},
	drift = {
		"CHEETAH 10450 16500 0 0 -0.18 -0.2 75 0.575 0.575 0.345 5 245 49.2 -50 r p 12.4 0.001 false 55 1.5 1.5 0 0.1 -0.04 0.65 0 0.9 0 105000 40002800 308803 0 0 1"
	}
}

local handlingProperties = {"identifier", "mass", "turnMass", "dragCoeff", "centerOfMassX", "centerOfMassY", "centerOfMassZ", "percentSubmerged", "tractionMultiplier", "tractionLoss", "tractionBias", "numberOfGears", "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "brakeDeceleration", "brakeBias", "ABS", "steeringLock", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping", "suspensionUpperLimit", "suspensionLowerLimit", "suspensionFrontRearBias", "suspensionAntiDiveMultiplier", "seatOffsetDistance", "collisionDamageMultiplier", "monetary", "modelFlags", "handlingFlags", "headLight", "tailLight", "animGroup", "identifier", "mass", "turnMass", "dragCoeff", "centerOfMassX", "centerOfMassY", "centerOfMassZ", "percentSubmerged", "tractionMultiplier", "tractionLoss", "tractionBias", "numberOfGears", "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "brakeDeceleration", "brakeBias", "ABS", "steeringLock", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping", "suspensionUpperLimit", "suspensionLowerLimit", "suspensionFrontRearBias", "suspensionAntiDiveMultiplier", "seatOffsetDistance", "collisionDamageMultiplier", "monetary", "modelFlags", "handlingFlags", "headLight", "tailLight", "animGroup"}

function hasVehicleHandling(vehicleName, handlingName, level)
	if type(vehicleName) ~= "string" then
		return false
	end
	if type(handlingsTable[vehicleName]) ~= "table" then
		return false
	end
	if type(handlingName) == "string" then
		if type(handlingsTable[vehicleName][handlingName]) ~= "table" then
			return false
		end
		if type(level) == "number" then
			if type(handlingsTable[vehicleName][handlingName][level]) ~= "string" then
				return false
			end
		end
	end
	return true
end

function getVehicleHandlingString(vehicleName, handlingName, level)
	if not hasVehicleHandling(vehicleName, handlingName, level) then
		return false
	end
	return handlingsTable[vehicleName][handlingName][level]
end

function getVehicleHandlingTable(vehicleName, handlingName, level)
	local handlingString = getVehicleHandlingString(vehicleName, handlingName, level)
	if type(handlingString) ~= "string" then
		return false
	end
	return importHandling(handlingString)
end

function getAllHandlingTables(handlingName, level)
	local result = {}
	for name, t in pairs(handlingsTable) do
		result[name] = getVehicleHandlingTable(name, handlingName, level)
	end
	return result
end