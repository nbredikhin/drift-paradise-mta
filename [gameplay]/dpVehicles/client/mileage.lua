local distanceCounter = 0
local previousPosition = Vector3()
if localPlayer.vehicle then
	previousPosition = localPlayer.position
end
local metersMul = 0.84178

setTimer(function ()
	if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
		distanceCounter = 0
		return
	end
	local passedDistance = (localPlayer.position - previousPosition):getLength()
	if passedDistance > 100 then
		return
	end
	distanceCounter = distanceCounter + math.floor(passedDistance * metersMul)
	previousPosition = localPlayer.position
	if distanceCounter >= 1000 then
		local currentMileage = localPlayer.vehicle:getData("mileage")
		if not currentMileage then
			return
		end
		localPlayer.vehicle:setData("mileage", currentMileage + 1)
		distanceCounter = 0
	end
end, 1000, 0)

addEventHandler("onClientPlayerVehicleEnter", root, function ()
	if source ~= localPlayer then
		return
	end
	previousPosition = localPlayer.position
end)