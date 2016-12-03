--exports.dpDuels:getNearestCheckpoint(player)

addEvent("dpDamage.respawn", true)
addEventHandler("dpDamage.respawn", resourceRoot, function ()
    local vehicle = client.vehicle
    if not vehicle then
        return
    end

    local spawnPos = PathGenerator.getNearestCheckpoint(client)
    if not spawnPos then
        return
    end
    client.vehicle.position = Vector3(spawnPos.x, spawnPos.y, spawnPos.z)
    client:setData("activeMap", false)
end)