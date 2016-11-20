local function repairVehicle(vehicle, closeDoors, serverSide)
    if not isElement(vehicle) then
        return
    end
    if vehicle.blown then
        return
    end    
    -- Восстановить hp
    vehicle.health = 1000
    -- Починить фары
    for i = 0, 3 do
        setVehicleLightState(vehicle, i, 0)
    end
    -- Починить двери
    for i = 0, 5 do
        setVehicleDoorState(vehicle, i, 0)
        if vehicle:getData("DoorState" .. tostring(i)) then
            vehicle:setDoorOpenRatio(i, 1)
        end
    end
    -- Починить панели
    for i = 0, 6 do
        setVehiclePanelState(vehicle, i, 0)
    end
end

-- Отключение повреждений автомобилей

local repairTimer

addEventHandler("onClientVehicleCollision", root, function (element, force)
    if source.blown then
        return
    end
    if force < 3 then
        return
    end
    cancelEvent()
    repairVehicle(source)
    if isTimer(repairTimer) then
        killTimer(repairTimer)
    end
    repairTimer = setTimer(repairVehicle, 300, 1, source)
end)

function isVehicleOnRoof(vehicle)
    if vehicle.blown then
        return false
    end    
    local rx, ry = getElementRotation(vehicle)
    if rx > 90 and rx < 270 or ry > 90 and ry < 270 then
        return true
    end
    return false
end

local blinkTimer
local blinkVehicle

function flipMyVehicle()
    if not localPlayer.vehicle then
        return
    end
    if localPlayer.vehicle.blown then
        return false
    end      
    localPlayer.vehicle.alpha = 255
    blinkTimer = setTimer(function()
        if not localPlayer.vehicle then
            if isTimer(blinkTimer) then
                killTimer(blinkTimer)
            end
            if isElement(blinkVehicle) then
                blinkVehicle.alpha = 255
            end
            localPlayer.alpha = 255
            return
        end

        if localPlayer.vehicle.alpha > 0 then
            localPlayer.vehicle.alpha = 0
        else
            localPlayer.vehicle.alpha = 255
        end
        localPlayer.alpha = localPlayer.vehicle.alpha
    end, 150, 12)
    localPlayer.vehicle.rotation = Vector3(0, 0, localPlayer.vehicle.rotation.z + 180)
end

local flipCounter = 0

-- Переворот автомобиля на колёса
setTimer(function ()
    if not localPlayer.vehicle then
        return
    end
    if localPlayer.vehicle.blown then
        return
    end    
    if localPlayer.vehicle.health < 1000 then
        repairVehicle(localPlayer.vehicle)
    end
    
    if isVehicleOnRoof(localPlayer.vehicle) and #localPlayer.vehicle.velocity < 0.4 and math.abs(localPlayer.vehicle.turnVelocity.x) < 0.007 then
        flipCounter = flipCounter + 1
        if flipCounter > 4 then
            flipMyVehicle()         
        end
    else
        flipCounter = 0
    end
end, 300, 0)