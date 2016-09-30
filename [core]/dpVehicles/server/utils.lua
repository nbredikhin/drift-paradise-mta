
local serverside = true

vehicleModelIdentifier = {
    [400] = "LANDSTAL",
    [401] = "BRAVURA",
    [402] = "BUFFALO",
    [403] = "LINERUN",
    [404] = "PEREN",
    [405] = "SENTINEL",
    [406] = "DUMPER",
    [407] = "FIRETRUK",
    [408] = "TRASH",
    [409] = "STRETCH",
    [410] = "MANANA",
    [411] = "INFERNUS",
    [412] = "VOODOO",
    [413] = "PONY",
    [414] = "MULE",
    [415] = "CHEETAH",
    [416] = "AMBULAN",
    [417] = "LEVIATHN",
    [418] = "MOONBEAM",
    [419] = "ESPERANT",
    [420] = "TAXI",
    [421] = "WASHING",
    [422] = "BOBCAT",
    [423] = "MRWHOOP",
    [424] = "BFINJECT",
    [425] = "HUNTER",
    [426] = "PREMIER",
    [427] = "ENFORCER",
    [428] = "SECURICA",
    [429] = "BANSHEE",
    [430] = "PREDATOR",
    [431] = "BUS",
    [432] = "RHINO",
    [433] = "BARRACKS",
    [434] = "HOTKNIFE",
    [435] = "ARTICT1",
    [436] = "PREVION",
    [437] = "COACH",
    [438] = "CABBIE",
    [439] = "STALLION",
    [440] = "RUMPO",
    [441] = "RCBANDIT",
    [442] = "ROMERO",
    [443] = "PACKER",
    [444] = "MONSTER",
    [445] = "ADMIRAL",
    [446] = "SQUALO",
    [447] = "SEASPAR",
    [448] = "MOPED",
    [449] = "TRAM",
    [450] = "ARTICT2",
    [451] = "TURISMO",
    [452] = "SPEEDER",
    [453] = "REEFER",
    [454] = "TROPIC",
    [455] = "FLATBED",
    [456] = "YANKEE",
    [457] = "GOLFCART",
    [458] = "SOLAIR",
    [459] = "TOPFUN",
    [460] = "SEAPLANE",
    [461] = "BIKE",
    [462] = "MOPED",
    [463] = "FREEWAY",
    [464] = "RCBARON",
    [465] = "RCRAIDER",
    [466] = "GLENDALE",
    [467] = "OCEANIC",
    [468] = "DIRTBIKE",
    [469] = "SPARROW",
    [470] = "PATRIOT",
    [471] = "QUADBIKE",
    [472] = "COASTGRD",
    [473] = "DINGHY",
    [474] = "HERMES",
    [475] = "SABRE",
    [476] = "RUSTLER",
    [477] = "ZR350",
    [478] = "WALTON",
    [479] = "REGINA",
    [480] = "COMET",
    [481] = "BMX",
    [482] = "BURRITO",
    [483] = "CAMPER",
    [484] = "MARQUIS",
    [485] = "BAGGAGE",
    [486] = "DOZER",
    [487] = "MAVERICK",
    [488] = "COASTMAV",
    [489] = "RANCHER",
    [490] = "FBIRANCH",
    [491] = "VIRGO",
    [492] = "GREENWOO",
    [493] = "CUPBOAT",
    [494] = "HOTRING",
    [495] = "SANDKING",
    [496] = "BLISTAC",
    [497] = "POLMAV",
    [498] = "BOXVILLE",
    [499] = "BENSON",
    [500] = "MESA",
    [501] = "RCGOBLIN",
    [502] = "HOTRING",
    [503] = "HOTRING",
    [504] = "BLOODRA",
    [505] = "RANCHER",
    [506] = "SUPERGT",
    [507] = "ELEGANT",
    [508] = "JOURNEY",
    [509] = "CHOPPERB",
    [510] = "MTB",
    [511] = "BEAGLE",
    [512] = "CROPDUST",
    [513] = "STUNT",
    [514] = "PETROL",
    [515] = "RDTRAIN",
    [516] = "NEBULA",
    [517] = "MAJESTIC",
    [518] = "BUCCANEE",
    [519] = "SHAMAL",
    [520] = "HYDRA",
    [521] = "FCR900",
    [522] = "NRG500",
    [523] = "HPV1000",
    [524] = "CEMENT",
    [525] = "TOWTRUCK",
    [526] = "FORTUNE",
    [527] = "CADRONA",
    [528] = "FBITRUCK",
    [529] = "WILLARD",
    [530] = "FORKLIFT",
    [531] = "TRACTOR",
    [532] = "COMBINE",
    [533] = "FELTZER",
    [534] = "REMINGTN",
    [535] = "SLAMVAN",
    [536] = "BLADE",
    [537] = "FREIGHT",
    [538] = "STREAK",
    [539] = "VORTEX",
    [540] = "VINCENT",
    [541] = "BULLET",
    [542] = "CLOVER",
    [543] = "SADLER",
    [544] = "FIRETRUK",
    [545] = "HUSTLER",
    [546] = "INTRUDER",
    [547] = "PRIMO",
    [548] = "CARGOBOB",
    [549] = "TAMPA",
    [550] = "SUNRISE",
    [551] = "MERIT",
    [552] = "UTILITY",
    [553] = "NEVADA",
    [554] = "YOSEMITE",
    [555] = "WINDSOR",
    [556] = "MTRUCK_A",
    [557] = "MTRUCK_B",
    [558] = "URANUS",
    [559] = "JESTER",
    [560] = "SULTAN",
    [561] = "STRATUM",
    [562] = "ELEGY",
    [563] = "RAINDANC",
    [564] = "RCTIGER",
    [565] = "FLASH",
    [566] = "TAHOMA",
    [567] = "SAVANNA",
    [568] = "BANDITO",
    [569] = "FREIFLAT",
    [570] = "CSTREAK",
    [571] = "KART",
    [572] = "MOWER",
    [573] = "DUNE",
    [574] = "SWEEPER",
    [575] = "BROADWAY",
    [576] = "TORNADO",
    [577] = "AT400",
    [578] = "DFT30",
    [579] = "HUNTLEY",
    [580] = "STAFFORD",
    [581] = "BF400",
    [582] = "NEWSVAN",
    [583] = "TUG",
    [584] = "PETROTR",
    [585] = "EMPEROR",
    [586] = "WAYFARER",
    [587] = "EUROS",
    [588] = "HOTDOG",
    [589] = "CLUB",
    [590] = "FREIFLAT",
    [591] = "ARTICT3",
    [592] = "ANDROM",
    [593] = "DODO",
    [594] = "RCCAM",
    [595] = "LAUNCH",
    [596] = "POLICE_LA",
    [597] = "POLICE_SF",
    [598] = "POLICE_VG",
    [599] = "POLRANGER",
    [600] = "PICADOR",
    [601] = "SWATVAN",
    [602] = "ALPHA",
    [603] = "PHOENIX",
    [604] = "GLENDALE",
    [605] = "SADLER",
    [606] = "BAGBOXA",
    [607] = "BAGBOXB",
    [608] = "STAIRS",
    [609] = "BOXBURG",
    [610] = "FARM_TR1",
    [611] = "UTIL_TR1"
}

-- Conform the above table to the opposite too
vehicleIdentifierModels = {}
for i,v in ipairs ( vehicleModelIdentifier ) do
    if not vehicleIdentifierModels[v] then
        vehicleIdentifierModels[v] = {}
    end
    
    table.insert ( vehicleIdentifierModels[v] , i )
end

--[[
    checkArguments ( table { "type", argument }, ... ) -- UNUSED
    
    validateResourcePointer ( string/userdata resource )
    
    isValidPlayer ( element player )
    isValidVehicle ( element vehicle )
    isValidVehicleModel ( int model )
    
    isHandlingPropertyValid ( string property )
    isHandlingPropertyCorrectable ( string property )
    isHandlingPropertyCenterOfMass ( string property )
    isHandlingPropertyHexadecimal ( string property )
    getHandlingLimits ( string property )
    isHandlingValueWithinLimits ( string property, int/float value )
    
    getVehicleIdentifierByModel ( integer model )
    getVehicleModelsByIdentifier ( string identifier )
    
    getHandlingPropertyNameFromID ( int id )
    getHandlingPropertyIDFromName ( string property )
    getHandlingPropertyInputType ( string property )
    
    getHandlingByteEnabled ( element vehicle, string property, integer byte, string value )
    
    getHandlingPreviousValue ( element vehicle, string property )
    
    setVehicleSaved ( element vehicle, bool saved )
    isVehicleSaved ( element vehicle )
    
    updateCache ( string cacheLib, string cacheChild, table cacheEntry )
    getEnabledValuesFromByteValue ( string byteValue )
    valueToString ( string property, var value )
    stringToValue ( string property, string value )
    numberToHex ( int integer )
    tobool ( var variable )
    RGBtoHEX ( ... )
    math.round ( int number )
    table.size ( table table )
]]

_emptyfn = function()end

-- Debug utility
Debug = setmetatable({}, {
        __index = function(t, k)
            return DEBUGMODE and _G[k] or _emptyfn
        end
    }
)

function checkArguments ( ... ) -- return success, type, value
    local types = {
        player = isValidPlayer,
        vehicle = isValidVehicle,
        vehicleModel = isValidVehicleModel,
        --resource = validateResourcePointer,
        property = isHandlingPropertyValid
    }
    
    for _,tab in ipairs ( {...} ) do
        if not types[ tab[1] ] ( tab[2] ) then
            return false, tab[1], tab[2]
        end
    end
    
    return false, nil, nil
end





function validateResourcePointer ( resource )
    if type ( resource ) == "userdata" then
        resource = getResourceName ( resource )
        
        if not resource then
            return false
        end
    end
    
    if type ( resource ) == "string" and not getResourceFromName ( resource )  then
        return false
    end
    
    return resource
end





function isValidPlayer ( player )
    if not isElement ( player ) or getElementType ( player ) ~= "player" then
        return false
    end
    
    return true
end





function isValidVehicle ( vehicle )
    if not isElement ( vehicle ) or getElementType ( vehicle ) ~= "vehicle" then
        return false
    end
    
    return true
end





function isValidVehicleModel ( model )
    if type ( model ) ~= "number" then
        error ( "Need a number!", 2 )
        return false
    end

    if model < 400 or model > 611 then
        return false
    end
    
    return true
end


--This function returns true if a setting is enabled in the meta, false otherwise.
function isHandlingPropertyEnabled(property)
    if getLocalPlayer then
        return (getElementData(resourceRoot, "propertySettings", false)[property]) or true
    else
        return tobool(get("*enable_"..property))
    end
end

function isHandlingPropertyValid ( property )
    if property == "centerOfMass" or handlingLimits[property] then
        return true
    end
    
    return false
end





function isHandlingPropertySupported ( property )
    local unsupported = {
        ["ABS"]=true, ["monetary"]=true, 
        ["headLight"]=true, ["tailLight"]=true,
        ["animGroup"]=true, ["identifier"]=true
    }
    
    return not unsupported[property]
end





function isHandlingPropertyCorrectable ( property )
    local props ={ 
        ["driveType"]=true, ["engineType"]=true,
        ["headLight"]=true, ["tailLight"]=true
    }
    
    return props[property] or false
end





function isHandlingPropertyCenterOfMass ( property )
    local props = {
        ["centerOfMassX"]=true, ["centerOfMassY"]=true,
        ["centerOfMassZ"]=true
    }
    
    return props[property] or false
end





function isHandlingPropertyHexadecimal ( property )
    if property == "modelFlags" or property == "handlingFlags" then
        return true 
    end
    
    return false
end





function getHandlingLimits ( property )
    if not isHandlingPropertyValid ( property ) then
        return false
    end

    if handlingLimits[property] and handlingLimits[property].limits then
        if tonumber ( handlingLimits[property].limits[1] ) then
            local min = tonumber(handlingLimits[property].limits[1])
            local max = tonumber(handlingLimits[property].limits[2])

            return min,max
        end

        return nil
    end

    return nil
end




--Returns true if the given value is within the limits for the handling type (as defined in shared\variables\handlingMTA.lua), false otherwise.
function isHandlingValueWithinLimits ( property, value )
    if handlingLimits[property] and handlingLimits[property].limits then
        local isNumeric = tonumber(handlingLimits[property].limits[1])
        if isNumeric and type ( value ) == "number" then
            local min,max = getHandlingLimits ( property )
            
            if value >= min then
                if value <= max then
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
    end
    
    return true
end





function getVehicleIdentifierByModel ( model )
    if isValidVehicleModel ( model ) then
        return vehicleModelIdentifier[model]
    end
    
    return nil
end





function getVehicleModelsByIdentifier ( identifier )
    return vehicleIdentifierModels[identifier]
end





function getHandlingPropertyNameFromID ( id )
    id = tonumber ( id )
    
    if not id then
        return false
    end
    
    return propertyID[id]
end





function getHandlingPropertyIDFromName ( property )
    if not isHandlingPropertyValid ( property ) then
        return false
    end
    
    return handlingLimits[property].id 
end





function getHandlingPropertyInputType ( property )
    if not isHandlingPropertyValid ( property ) then
        return false
    end
    
    return handlingLimits[property].input
end





function getHandlingOptionID ( property, option )
    if not isHandlingPropertyValid ( property ) then
        return false
    end
    
    if not handlingLimits[property] or type ( handlingLimits[property].options ) ~= "table" then
        return false
    end
    
    for i,v in ipairs ( handlingLimits[property].options ) do
        if v == option then
            return i
        end
    end
    
    return false
end





function getHandlingByteEnabled ( property, byte, value, byteValue ) -- Seems to be invalid!
    if not isHandlingPropertyValid ( property ) then
        return nil
    end
    
    if not isHandlingPropertyHexadecimal ( property ) then
        return nil
    end
    
    local function toValue ( hex )
        local tbl = { ["1"]={"1"},         ["2"]={"2"},         ["3"]={"1","2"},     ["4"]={"4"},     ["5"]={"1","4"},
                      ["6"]={"2","4"},     ["7"]={"1","2","4"}, ["8"]={"8"},         ["9"]={"1","8"}, ["A"]={"2","8"}, 
                      ["B"]={"1","2","8"}, ["C"]={"4","8"},     ["D"]={"1","4","8"}, ["E"]={"1","2","4","8"} }
        return tbl[hex]
    end
    
    local val = toValue ( byteValue )
    if val[value] then 
        return true
    end
    
    return false
end





function getHandlingPreviousValue ( vehicle, property )
    if not isValidVehicle ( vehicle ) then
        return false
    end
    
    if not isHandlingPropertyValid ( property ) then
        return false
    end
    
    return getElementData ( vehicle, "hedit:vehiclepreviousvalue."..property )
end





function setVehicleSaved ( vehicle, saved )
    if not isValidVehicle ( vehicle ) then
        return false
    end
    
    if clientside then
        triggerServerEvent ( "setSaved", root, vehicle, saved )
        return true
    end
    
    setElementData ( vehicle, "hedit:saved", tostring ( saved ) )
    
    local occupants = getVehicleOccupants ( vehicle )
    local seats = getVehicleMaxPassengers ( vehicle )
    
    for seat=0,seats do
        local player = occupants[seat]
        
        if isValidPlayer ( player ) then
            triggerClientEvent ( player, "updateVehicleText", vehicle )
        end
    end
    
    return true
end
if serverside then
    addEvent ( "setSaved", true )
    addEventHandler ( "setSaved", root, setVehicleSaved )
end




function isVehicleSaved ( vehicle )
    if not isValidVehicle ( vehicle ) then
        return false
    end
    
    if not getElementData ( vehicle, "hedit:saved" ) then
        setElementData ( vehicle, "hedit:saved", "true" )
    end
    
    return tobool ( getElementData ( vehicle, "hedit:saved" ) )
end





function getEnabledValuesFromByteValue ( byteValue )
    local tbl = { ["1"]={"1"},         ["2"]={"2"},         ["3"]={"1","2"},     ["4"]={"4"},     ["5"]={"1","4"},
                  ["6"]={"2","4"},     ["7"]={"1","2","4"}, ["8"]={"8"},         ["9"]={"1","8"}, ["A"]={"2","8"}, 
                  ["B"]={"1","2","8"}, ["C"]={"4","8"},     ["D"]={"1","4","8"}, ["F"]={"1","2","4","8"} }          
    return tbl[byteValue] or {}
end





function valueToString ( property, value )
    if type ( value ) == "number" then
        
        value = math.round ( value )
        
    elseif type ( value ) == "table" then -- Previously for centerOfMass, but property is disabled.
        
        local str = ""
        
        for i,v in ipairs ( value ) do
            str = str..math.round ( v ).. ( i < #value and ", " or "" )
        end
        
        value = str

    end
    
    return tostring ( value )
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





function numberToHex ( num )
    if type ( num ) ~= "number" then
        error ( "Need a number!", 2 )
        return false
    end
    
    local hexnums = {
        "0","1","2","3","4","5","6","7",
        "8","9","A","B","C","D","E","F"
    }
    local hex,m = "",num%16
    
    if (num-m) == 0 then
        return hexnums[m+1]
    end
    
    if not hexnums[m+1] then
        outputChatBox ( tostring ( m ) )
    end

    return numberToHex((num-m)/16)..hexnums[m+1]
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


--Returns true if the given value is numeric, false otherwise.
function isNumeric(value)
    return (tonumber(value) and true) or false
end



function RGBtoHEX(...)
    return string.format ( string.rep ( "%.2X", #{...} ), unpack ( {...} ) )
end





function math.round ( number, float )
    if not float then
        float = 3
    end
    
    if type ( number ) == "number" then
        return tonumber ( string.format ( "%."..tostring(float).."f", number ) )
    end
    
    outputDebugString ( "Not a number at math.round! ["..tostring(number).."]" )
    return number
end





function table.size ( tab )
    local length = 0
    
    for _ in pairs ( tab ) do
        length = length + 1
    end
    
    return length
end


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

_getOriginalHandling = getOriginalHandling
_getVehicleHandling = getVehicleHandling
if serverside then
    _setVehicleHandling = setVehicleHandling
end





function getVehicleHandling ( vehicle )
    if not isValidVehicle ( vehicle ) then 
        error ( "Invalid vehicle element at 'getVehicleHandling'! [arg:1]", 2 )
    end
    
    local handling = _getVehicleHandling ( vehicle )
    if not handling then
        error ( "Something went wrong. Does the vehicle still exist?", 2 )
    end
    
    return conformHandlingTable ( handling, getElementModel ( vehicle ) )
end





function setVehicleHandling ( vehicle, property, value, withLog )
    if not isValidVehicle ( vehicle ) then
        return false
    end
    
    if not isHandlingPropertyValid ( property ) then
        return false
    end
    
    if not value then
        return false
    end
    local setValue = value
    
    if isHandlingPropertyCorrectable ( property ) then
        local corrected = isValueCorrected ( value )
        
        if not corrected then
            setValue = getOriginalHandlingValue ( value )
        elseif corrected == nil then
            return false
        end   
    elseif isHandlingPropertyCenterOfMass ( property ) then
        local com = _getVehicleHandling ( vehicle )["centerOfMass"]
        if property == "centerOfMassX" then
            setValue = { value, com[2], com[3] }
        elseif property == "centerOfMassY" then
            setValue = { com[1], value, com[3] }
        elseif property == "centerOfMassZ" then
            setValue = { com[1], com[2], value }
        end
    elseif isHandlingPropertyHexadecimal ( property ) and type ( value ) == "string" then
        setValue = tonumber ( "0x"..value )  
    elseif property == "centerOfMass" then
        if type ( value ) ~= "table" then
            setValue  = {
                tonumber ( gettok ( value, 1, 44 ) ),
                tonumber ( gettok ( value, 2, 44 ) ),
                tonumber ( gettok ( value, 3, 44 ) )
            }
        end
    else
        local num = tonumber ( value )
        if not num then
            return false
        end

        setValue = num
    end

    if not isHandlingPropertySupported(property) then
        return false
    end
    if not isHandlingValueWithinLimits(property, setValue) then
        return false
    end

    local oldValue = getVehicleHandling(vehicle)[property]
    if property == "centerOfMass" then
        local hnd = getVehicleHandling ( vehicle )
        oldValue = math.round ( hnd.centerOfMassX )..", "..math.round ( hnd.centerOfMassY )..", "..math.round ( hnd.centerOfMassZ )
    end

    local setProperty = isHandlingPropertyCenterOfMass ( property ) and "centerOfMass" or property
    if not _setVehicleHandling ( vehicle, setProperty, setValue ) then
        outputDebugString ( "Can't change property "..property.." to value '"..tostring(value).."'" )
        return false
    end
    return true
end
if serverside then
    addEvent ( "setHandling", true )
    addEventHandler ( "setHandling", root, setVehicleHandling )
end





function getOriginalHandling ( model, force )
    if not force and not isValidVehicleModel ( model ) then
        error ( "Invalid model given at 'getOrignalHandling'! [arg:1,"..tostring(model).."]", 2 )
        return nil
    end
    
    local data = getElementData ( root, "originalHandling."..tostring(model) )
    if not data or force then
        data = conformHandlingTable ( _getOriginalHandling ( model ), model )
    end
    
    return data
end





local correctedValues = {
    ["fwd"] = "f",
    ["rwd"] = "r",
    ["awd"] = "4",
    ["petrol"] = "p",
    ["diesel"] = "d",
    ["electric"] = "e",
    ["long"] = 0,
    ["small"] = 1,
    ["big"] = 2,
}

local originalValues = {}
for k,v in pairs ( correctedValues ) do
    originalValues[v] = k
end    

function getCorrectedHandlingValue ( value )
    return correctedValues[value] or 3 -- or 3 is when head or taillight is 'tall', this has not been implemented in MTA
end

function getOriginalHandlingValue ( value )
    return originalValues[value] or "big" -- as 3 cant be converted to 'tall', we use 'big'
end

function isValueCorrected ( value )
    if correctedValues[value] then
        return true
    end
    if originalValues[value] then
        return false
    end
    return nil
end



function conformHandlingTable ( handling, model )
    handling["identifier"] = getVehicleIdentifierByModel ( model )
    handling["centerOfMassX"] = handling["centerOfMass"][1]
    handling["centerOfMassY"] = handling["centerOfMass"][2]
    handling["centerOfMassZ"] = handling["centerOfMass"][3]
    handling["driveType"] = getCorrectedHandlingValue ( handling["driveType"] )
    handling["engineType"] = getCorrectedHandlingValue ( handling["engineType"] )
    handling["headLight"] = getCorrectedHandlingValue ( handling["headLight"] )
    handling["tailLight"] = getCorrectedHandlingValue ( handling["tailLight"] )
    handling["modelFlags"] = string.format ( "%X", handling["modelFlags"] )
    handling["handlingFlags"] = string.format ( "%X", handling["handlingFlags"] )
    
    handling["centerOfMass"] = nil
    return handling
end