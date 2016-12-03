local function restartVehicleEngine()
    if localPlayer.vehicle then
        setVehicleEngineState(localPlayer.vehicle, true)
    end
end

setTimer(function ()
    if not localPlayer.vehicle then
        return
    end

    if localPlayer.vehicle.inWater then
        triggerServerEvent("dpDamage.respawn", resourceRoot)
        flipMyVehicle()
        setTimer(restartVehicleEngine, 1000, 1)
    end
end, 3000, 0)