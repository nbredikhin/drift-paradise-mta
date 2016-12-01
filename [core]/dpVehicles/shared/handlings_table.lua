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
		"CLUB 11000 11000 0 0 0.1 -0.2 120 0.725 0.725 0.415 5 185 9.4 45 r p 4.3 0.5 false 22 1.5 1.5 0 0.26 -0.12 0.5 0 0.37 0 35000 40000004 C00000 1 1 0",
		"CLUB 11000 11000 0 0 0.1 -0.2 120 0.755 0.715 0.415 5 225 14.8 110 r p 4.3 0.5 false 22 1.5 1.5 0 0.26 -0.12 0.5 0 0.37 0 35000 40000004 C00000 1 1 0"
	},
	drift = {
		"CLUB 10450 15700 0 0 -0.18 -0.2 75 0.565 0.565 0.395 5 225 21.2 5 r p 12.4 0.001 false 50 1.5 1.5 0 0.26 -0.12 0.5 0 0.9 0 35000 40000800 300003 1 1 0"
	}
}

handlingsTable["nissan_180sx"] = {
	street = {
		"ALPHA 11000 11000 1 0 0.1 -0.2 85 0.75 0.8 0.5 5 215 6.6 20 r p 5 0.55 false 21 0.72 0.12 0 0.33 -0.15 0.5 0.4 0.9 0 35000 40000800 200000 1 1 0",
		"ALPHA 11000 11000 1 0 0.1 -0.2 85 0.765 0.795 0.435 5 225 8.9 105 r p 5.1 0.55 false 22 0.72 0.12 0 0.33 -0.15 0.5 0.4 0.9 0 35000 40000800 200000 1 1 0"
	},
	drift = {
		"ALPHA 10450 14500 0 0 -0.18 -0.2 75 0.575 0.575 0.368 5 245 22.2 -5 r p 12.4 0.001 false 50 1.5 1.5 0 0.33 -0.15 0.5 0 0.9 0 35000 40000800 300003 1 1 0"
	}
}

handlingsTable["nissan_gtr35"] = {
	street = {
		"URANUS 11000 11000 0 0 0.1 -0.2 120 0.725 0.725 0.455 5 320 20.1 85 4 p 4.9 0.5 false 22 1.7 0.15 0 0.3 -0.1 0.5 0 1 0 35000 C0002800 4B00003 1 1 0",
		"URANUS 11000 11000 0 0 0.1 -0.2 120 0.725 0.725 0.495 5 320 20.1 75 4 p 4.9 0.5 false 22 1.7 0.15 0 0.3 -0.1 0.5 0 1 0 35000 C0002800 4B00003 1 1 0"
	},
	drift = {
		"URANUS 11000 15150 5.545 0 0.1 -0.2 120 0.645 0.635 0.395 5 320 70.3 -14.5 r p 12.145 0.025 false 55 1.7 2.15 5.545 0.3 -0.1 0.5 0 1 0 35000 C0002800 4B04403 1 1 0"
	}
}

handlingsTable["bmw_e30"] = {
	street = {
		"MANANA 11000 11000 0 0 0 0 120 0.615 0.615 0.485 5 215 7.2 41.5 r d 3.15 0.415 false 22 1.7 0.1 5 0.45 -0.15 0.5 0 0.72 0 9000 0 0 0 0 0",
		"MANANA 11000 11000 0 0 0 0 120 0.705 0.805 0.455 5 255 10.9 105 r d 3.15 0.415 false 24 1.7 0.1 5 0.45 -0.15 0.5 0 0.72 0 9000 0 0 0 0 0"
	},
	drift = {
		"MANANA 11000 19500 5.455 0 0.1 -0.2 120 0.625 0.625 0.385 4 265 48.435 -7.9 r p 14.245 0.025 false 55 1.7 2.355 5.455 0.45 -0.15 0.5 0 0.75 0 9000 2000 F00003 0 0 0"
	}
}

handlingsTable["bmw_e34"] = {
	street = {
		"WILLARD 11000 11000 0 0 0 0 120 0.645 0.645 0.455 5 235 8.4 34.5 r d 3.45 0.355 false 22 1.7 0.2 0 0.42 -0.14 0.5 0 0.72 0 19000 40000000 0 0 3 0",
		"WILLARD 11000 11000 0 0 0 0 120 0.705 0.815 0.5 5 265 10.4 105 r d 3.95 0.455 false 24 1.7 0.2 0 0.42 -0.14 0.5 0 0.72 0 19000 40000000 0 0 3 0"
	},
	drift = {
		"WILLARD 11000 14000 0 0 0.1 -0.2 120 0.605 0.655 0.465 4 265 42.655 -19.4 r d 13.95 0.055 false 55 1.7 0.2 0 0.42 -0.14 0.5 0 0.72 0 19000 40000000 0 0 3 0"
	}
}

handlingsTable["bmw_e60"] = {
	street = {
		"VINCENT 11000 11000 0 0 0 0 120 0.665 0.685 0.455 5 255 9.1 37.5 r d 4.4 0.365 false 28 1.7 0.2 0 0.2 -0.16 0.56 0 0.72 0 19000 2000 2 0 3 0",
		"VINCENT 11000 11000 0 0 0 0 120 0.705 0.805 0.455 5 275 11.4 105 r d 4.45 0.455 false 34 1.7 0.2 0 0.2 -0.16 0.56 0 0.72 0 19000 2000 2 0 3 0"
	},
	drift = {
		"VINCENT 11000 18700 0 0 -0.1 -0.05 120 0.615 0.615 0.385 4 275 43.545 -21.45 r d 14.45 0.025 false 55 1.7 0.2 0 0.2 -0.16 0.56 0 0.72 0 19000 2000 2 0 3 0"
	}
}

handlingsTable["bmw_e46"] = {
	street = {
		"PREVION 11000 11000 0 0 0 0 120 0.675 0.685 0.455 5 245 11.4 34.5 r d 4.45 0.455 false 28 1.7 0.2 0 0.4 -0.18 0.55 0 0.72 0 9000 2000 2 0 0 0",
		"PREVION 11000 11000 0 0 0 0 120 0.735 0.835 0.455 5 255 13.4 105 r d 4.45 0.455 false 34 1.7 0.2 0 0.4 -0.18 0.55 0 0.72 0 9000 2000 2 0 0 0"
	},
	drift = {
		"PREVION 11000 18700 0 0 -0.1 -0.05 120 0.565 0.565 0.385 4 275 43.545 -21.45 r d 14.45 0.025 false 55 1.7 0.2 0 0.4 -0.18 0.55 0 0.72 0 9000 2000 2 0 0 0"
	}
}

handlingsTable["nissan_skyline2000"] = {
	street = {
		"SLAMVAN 11000 11000 0 0 0 0 120 0.725 0.725 0.465 5 185 13.6 95 r p 4.1 0.355 false 22 1.6 0.12 0 0.35 -0.14 0.5 0.3 0.72 0 19000 40000000 0 1 3 0",
		"SLAMVAN 11000 11000 0 0 0.1 -0.2 120 0.755 0.715 0.505 5 225 21.2 100 r p 4.4 0.505 false 24 1.6 0.12 0 0.35 -0.14 0.5 0.3 0.72 0 19000 40000000 0 1 3 0"
	},
	drift = {
		"SLAMVAN 11000 13500 2 0 -0.18 -0.2 120 0.565 0.565 0.395 5 225 24.2 5 r p 14.4 0.035 false 50 1.6 0.12 0 0.35 -0.14 0.5 0.3 0.72 0 19000 40000000 0 1 3 0"
	}
}

handlingsTable["honda_civic"] = {
	street = {
		"FLASH 11000 11000 0 0 0.1 -0.2 120 0.725 0.725 0.415 5 190 8.1 45 f p 4.3 0.5 false 22 1.5 1.5 0 0.35 -0.1 0.5 0 0.37 0 35000 40000004 C00000 1 1 1",
		"FLASH 11000 11000 0 0 0.1 -0.2 120 0.855 0.855 0.425 5 225 11.9 90 f p 4.3 0.5 false 24 1.5 1.5 0 0.35 -0.1 0.5 0 0.37 0 35000 40000004 C00000 1 1 1"
	},
	drift = {

	}
}

handlingsTable["nissan_silvia_s13"] = {
	street = {
		"BRAVURA 11000 11000 1 0 0.1 -0.2 85 0.75 0.8 0.5 5 225 6.9 20 f p 5 0.55 false 24 0.72 0.12 0 0.31 -0.2 0.57 0.4 0.9 0 9000 40000800 200000 0 0 0",
		"BRAVURA 11000 11000 1 0 0.1 -0.2 85 0.765 0.795 0.435 5 237 9.2 105 f p 5.1 0.55 false 22 0.72 0.12 0 0.31 -0.2 0.57 0.4 0.9 0 9000 40000800 200000 0 0 0"
	},
	drift = {
		"BRAVURA 10450 14500 0 0 -0.18 -0.2 75 0.575 0.575 0.368 5 245 22.2 -5 r p 12.4 0.001 false 50 1.5 1.5 0 0.31 -0.1 0.57 0 0.9 0 9000 40000800 300003 0 0 0"
	}
}

handlingsTable["nissan_silvia_s14"] = {
	street = {
		"TORNADO 11000 11000 1 0 0.1 -0.2 85 0.75 0.8 0.5 5 235 8.6 34.5 r p 5 0.55 false 24 0.72 0.12 0 0.31 -0.19 0.5 0.4 0.9 0 19000 40000800 200000 1 1 0",
		"TORNADO 11000 11000 1 0 0.1 -0.2 85 0.765 0.795 0.435 5 260 9.4 105 r p 5.1 0.55 false 22 0.72 0.12 0 0.31 -0.19 0.5 0.4 0.9 0 19000 40000800 200000 1 1 0"
	},
	drift = {
		"TORNADO 11000 18700 0 0 -0.1 -0.05 120 0.565 0.565 0.385 4 275 43.545 -21.45 r d 14.45 0.025 false 55 1.7 0.2 0 0.31 -0.1 0.5 0 0.9 0 19000 0 2 1 1 0"
	}
}

handlingsTable["nissan_skyline_gtr34"] = {
	street = {
		"ELEGY 11000 11000 0 0 0 0 120 0.675 0.685 0.455 5 250 11 100 4 p 3.8 0.455 false 28 1.7 0.2 0 0.27 -0.11 0.55 0 0.72 0 35000 0 2 1 1 1",
		"ELEGY 11000 11000 0 0 0 0 120 0.675 0.685 0.455 5 270 11.4 105 4 p 3.7 0.455 false 30 1.7 0.2 0 0.27 -0.11 0.55 0 0.72 0 35000 0 2 1 1 1"
	},
	drift = {
		"ELEGY 11000 18700 0 0 -0.1 -0.05 120 0.565 0.565 0.385 4 275 43.545 -21.45 r d 14.45 0.025 false 55 1.7 0.2 0 0.27 -0.1 0.55 0 0.9 0 35000 3000 2 1 1 1"
	}
}

handlingsTable["mazda_rx8"] = {
	street = {
		"SUNRISE 11000 11000 1 0 0.1 -0.2 85 0.75 0.8 0.5 5 240 8.9 34.5 r p 5 0.55 false 24 0.72 0.12 0 0.36 -0.17 0.55 0.4 0.9 0 19000 40002800 200000 0 3 0",
		"SUNRISE 11000 11000 1 0 0.1 -0.2 85 0.75 0.8 0.5 5 260 9.4 34 r p 5 0.55 false 24 0.72 0.12 0 0.36 -0.17 0.55 0.4 0.9 0 19000 40002800 200000 0 3 0"
	},
	drift = {
		"SUNRISE 11000 18700 0 0 -0.1 -0.05 120 0.565 0.565 0.385 4 275 43.545 -21.45 r d 14.45 0.025 false 55 1.7 0.2 0 0.36 -0.04 0.55 0 0.72 0 19000 2000 2 0 3 0"
	}
}

handlingsTable["nissan_datsun_240z"] = {
	street = {
		"SABRE 11000 11000 0 0 0 0 120 0.615 0.615 0.485 5 195 7 41.5 r p 3.8 0.415 false 22 1.7 0.1 5 0.49 -0.15 0.43 0 0.9 0 19000 0 0 1 1 0",
		"SABRE 11000 11000 0 0 0 0 120 0.615 0.615 0.485 5 230 7.8 40.2 r p 3.8 0.415 false 22 1.7 0.1 5 0.49 -0.15 0.43 0 0.9 0 19000 0 0 1 1 0"
	},
	drift = {
		"SABRE 11000 19500 5.455 0 0.1 -0.2 120 0.625 0.625 0.385 4 265 48.435 -7.9 r p 14.245 0.025 false 55 1.7 2.355 5.455 0.49 -0.15 0.5 0 0.9 0 19000 0 F00003 1 1 0"
	}
}

handlingsTable["lamborghini_aventador"] = {
	street = {
		"SUPERGT 11000 11000 0 0 -0.2 -0.2 70 0.945 0.945 0.5 5 350 39.9 225 4 p 7.4 0.5 false 22 0.8 0.2 0 0.25 -0.14 0.5 0.6 0.4 0 105000 C0222004 208000 0 0 1",
		"SUPERGT 11000 11000 0 0 -0.2 -0.2 70 0.945 0.945 0.5 5 380 41.4 225 4 p 6 0.5 false 25 0.8 0.2 0 0.25 -0.14 0.5 0.6 0.4 0 105000 C0222004 208000 0 0 1"
	},
	drift = {
		"SUPERGT 10450 16500 0 0 -0.18 -0.2 75 0.575 0.575 0.345 5 245 49.2 -50 r p 12.4 0.001 false 55 1.5 1.5 0 0.25 -0.07 0.54 0 0.9 0 105000 40002800 308003 0 0 1"
	}
}

handlingsTable["ferrari_458_italia"] = {
	street = {
		"TURISMO 11000 11000 0 0 -0.2 -0.2 70 0.945 0.945 0.35 5 320 30 250 r p 6 0.5 false 25 0.8 0.2 0 0.15 -0.12 0.5 0.6 0.4 0 95000 C0222004 208400 1 1 1",
		"TURISMO 11000 11000 0 0 -0.2 -0.2 70 0.945 0.945 0.35 5 345 38 230 r p 6 0.5 false 25 0.8 0.2 0 0.15 -0.12 0.5 0.6 0.4 0 95000 C0222004 208400 1 1 1"
	},
	drift = {
	}
}

handlingsTable["lamborghini_huracan"] = {
	street = {
		"CHEETAH 11000 11000 0 0 -0.2 -0.2 70 0.945 0.945 0.5 5 320 30 250 4 p 7.4 0.5 false 25 0.8 0.2 0 0.12 -0.1 0.5 0.6 0.4 0 105000 C0002004 204400 0 0 1",
		"CHEETAH 11000 11000 0 0 -0.2 -0.2 70 0.945 0.945 0.5 5 350 38 240 4 p 7.4 0.5 false 25 0.8 0.2 0 0.12 -0.1 0.5 0.6 0.4 0 105000 C0002004 204400 0 0 1"
	},
	drift = {
		"CHEETAH 10450 16500 0 0 -0.18 -0.2 75 0.575 0.575 0.345 5 245 49.2 -50 r p 12.4 0.001 false 55 1.5 1.5 0 0.12 -0.08 0.57 0 0.9 0 105000 40222800 308003 0 0 1"
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
		if #handlingsTable[vehicleName][handlingName] == 0 then
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