local tuningTable = {}
local tuningTableIndexes = {
    level       = 1,
    FrontBump   = 2,
    RearBump    = 2,
    SideSkirts  = 3,
    Spoilers    = 5,
    FrontFends  = 7,
    RearFends   = 7,
    Bonnets     = 6,
    RearLights  = 4,
    FrontLights = 4
}

-- Настройки по умолчанию
-- используются, если для автомобиля не прописаны цены

-- {Цена, Уровень}
local defaultTuningTable = {
    -- Стоковые компоненты всегда бесплатные
    components = {
        FrontBump   = {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
        RearBump    = {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
        SideSkirts  = {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
        Spoilers    = {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
        FrontFends  = {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
        RearFends   = {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
        Bonnets     = {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
        RearLights  = {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
        FrontLights = {{0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}, {0, 1}},
    }
}

-- Возвращает таблицу в формате
-- tuningTable.components[ComponentName][ComponentID] = { price, level }
function getVehicleTuningTable(vehicleName)
    return defaultTuningTable
    -- if type(vehicleName) ~= "string" then
    --     outputDebugString("Invalid vehicle name: " .. tostring(vehicleName))
    --     return defaultTuningTable
    -- end
    -- if tuningTable[vehicleName] then
    --     local resultTable = {}
    --     for componentName, index in pairs(tuningTableIndexes) do
    --         local componentTable = {}
    --         for i, price in ipairs(tuningTable[vehicleName][index]) do
    --             table.insert(componentTable, {
    --                 price, 
    --                 tuningTable[vehicleName][1][i]
    --             })
    --         end
    --         resultTable[componentName] = componentTable
    --     end
    --     return {components = resultTable}
    -- else
    --     outputDebugString(string.format("Warning: no tuning table for \"%s\"", tostring(vehicleName)))
    --     return defaultTuningTable
    -- end
end