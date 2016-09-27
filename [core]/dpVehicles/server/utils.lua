
handlingLimits = { 
    ["identifier"] = {
        id = 1,
        input = "string",
        limits = { "", "" },
    },
    ["mass"] = {
        id = 2,
        input = "float",
        limits = { "1.0", "100000.0" }
    },
    ["turnMass"] = {
        id = 3,
        input = "float",
        limits = { "0.0", "1000000.0" }
    },
    ["dragCoeff"] = {
        id = 4,
        input = "float",
        limits = { "0.0", "200.0" }
    },
    ["centerOfMassX"] = {
        id = 5,
        input = "float",
        limits = { "-10", "10" }
    },
    ["centerOfMassY"] = {
        id = 6,
        input = "float",
        limits = { "-10", "10" }
    },
    ["centerOfMassZ"] = {
        id = 7,
        input = "float",
        limits = { "-10", "10" }
    },
    ["percentSubmerged"] = {
        id = 8,
        input = "integer",
        limits = { "1", "120" }
    },
    ["tractionMultiplier"] = {
        id = 9,
        input = "float",
        limits = { "0.0", "100000.0" }
    },
    ["tractionLoss"] = {
        id = 10,
        input = "float",
        limits = { "0.0", "100.0" }
    },
    ["tractionBias"] = {
        id = 11,
        input = "float",
        limits = { "0.0", "1.0" }
    },
    ["numberOfGears"] = {
        id = 12,
        input = "integer",
        limits = { "1", "5" }
    },
    ["maxVelocity"] = {
        id = 13,
        input = "float",
        limits = { "0.1", "200000.0" }
    },
    ["engineAcceleration"] = {
        id = 14,
        input = "float",
        limits = { "0.0", "100000.0" }
    },
    ["engineInertia"] = {
        id = 15,
        input = "float",
        limits = { "-1000.0", "1000.0" }
    },
    ["driveType"] = {
        id = 16,
        input = "string",
        limits = { "", "" },
        options = { "f","r","4" }
    },
    ["engineType"] = {
        id = 17,
        input = "string",
        limits = { "", "" },
        options = { "p","d","e" }
    },
    ["brakeDeceleration"] = {
        id = 18,
        input = "float",
        limits = { "0.1", "100000.0" }
    },
    ["brakeBias"] = {
        id = 19,
        input = "float",
        limits = { "0.0", "1.0" }
    },
    ["ABS"] = {
        id = 20,
        input = "boolean",
        limits = { "", "" },
        options = { "true","false" }
    },
    ["steeringLock"] = {
        id = 21,
        input = "float",
        limits = { "0.0", "360.0" }
    },
    ["suspensionForceLevel"] = {
        id = 22,
        input = "float",
        limits = { "0.0", "100.0" }
    },
    ["suspensionDamping"] = {
        id = 23,
        input = "float",
        limits = { "0.0", "100.0" }
    },
    ["suspensionHighSpeedDamping"] = {
        id = 24,
        input = "float",
        limits = { "0.0", "600.0" }
    },
    ["suspensionUpperLimit"] = {
        id = 25,
        input = "float",
        limits = { "-50.0", "50.0" }
    },
    ["suspensionLowerLimit"] = {
        id = 26,
        input = "float",
        limits = { "-50.0", "50.0" }
    },
    ["suspensionFrontRearBias"] = {
        id = 27,
        input = "float",
        limits = { "0.0", "1.0" }
    },
    ["suspensionAntiDiveMultiplier"] = {
        id = 28,
        input = "float",
        limits = { "0.0", "30.0" }
    },
    ["seatOffsetDistance"] = {
        id = 29,
        input = "float",
        limits = { "0.0", "20.0" }
    },
    ["collisionDamageMultiplier"] = {
        id = 30,
        input = "float",
        limits = { "0.0", "100.0" }
    },
    ["monetary"] = {
        id = 31,
        input = "integer",
        limits = { "0", "230195200" }
    },
    ["modelFlags"] = {
        id = 32,
        input = "hexadecimal",
        limits = { "", "" },
    },
    ["handlingFlags"] = {
        id = 33,
        input = "hexadecimal",
        limits = { "", "" },
    },
    ["headLight"] = {
        id = 34,
        input = "integer",
        limits = { "0", "3" },
        options = { 0,1,2,3 }
    },
    ["tailLight"] = {
        id = 35,
        input = "integer",
        limits = { "0", "3" },
        options = { 0,1,2,3 }
    },
    ["animGroup"] = {
        id = 36,
        input = "integer",
        limits = { "0", "30" }
    }
}

propertyID = {}
for k,v in pairs ( handlingLimits ) do
    propertyID[v.id] = k    
end

function isHandlingPropertyHexadecimal ( property )
    if property == "modelFlags" or property == "handlingFlags" then
        return true 
    end
    
    return false
end

function getHandlingPropertyNameFromID ( id )
    id = tonumber ( id )
    
    if not id then
        return false
    end
    
    return propertyID[id]
end

function tobool ( var )
    if type(var) == "nil" then return nil end
    local conform = {
        [0]=false, [1] = true,
        ["0"]=false, ["1"] = true,
        ["false"] = false, ["true"] = true,
        [true] = true, [false] = false,
    }
    local t = type ( var )
    if t == "number" or t == "string" or t == "boolean" then
        if conform[var] == nil then
            error ( "Invalid string or number given to convert at 'tobool'! [arg:1,"..tostring(var).."]", 2 )
        end
        return conform[var]
    end
    error ( "Invalid value to convert at 'tobool'! [arg:1,"..tostring(var).."]", 2 )
    return nil
end


function stringToValue ( property, value )
    if property == "ABS" then
        return tobool ( value )
    end
    
    if isHandlingPropertyHexadecimal ( property ) then
        return tonumber ( "0x"..value )
    end
    
    if property == "driveType" or property == "engineType" then
        return value
    end
    
    return tonumber ( value ) or value
end

-- Imports a handling line in handling.cfg format, given a proper method.
-- Valid methods: III, VC, SA, and IV
function importHandling (handlingLine )
	-- Split the line into a table.
	local handlingValues = {}
	for handlingValue in string.gmatch(handlingLine, "[^%s]+") do
		table.insert(handlingValues, handlingValue)
	end

	local handlingTable = {}

	local id = 1
	local vIdentifierFound = false

	for value in string.gmatch ( handlingLine, "[^%s]+" ) do
		if not vIdentifierFound and tonumber ( value ) then
			vIdentifierFound = true
		end
    
		if vIdentifierFound then
			id = id + 1
			local property = getHandlingPropertyNameFromID ( id )
        
			if property then
				handlingTable[property] = stringToValue ( property, value )
			end
		end
	end

	if id ~= 36 then
		return false
	end
	return handlingTable
end