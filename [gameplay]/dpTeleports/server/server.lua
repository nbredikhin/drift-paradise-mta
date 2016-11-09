addEvent("dpTeleports.resetDimension", true)
addEventHandler("dpTeleports.resetDimension", resourceRoot, function ()
    client.dimension = 0
    client.interior = 0
    if client.vehicle then
        client.vehicle.dimension = 0
        client.vehicle.interior = 0
    end
end)