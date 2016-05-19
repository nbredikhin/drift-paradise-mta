local frontWheels = {"wheel_lf_dummy", "wheel_rf_dummy"}
local rearWheels = {"wheel_lb_dummy", "wheel_rb_dummy"}

local function updateVehicleConfiguration(vehicle)
	-- Вынос передних колёс
	local offsetFront = vehicle:getData("WheelsOffsetF")
	if type(offsetFront) == "number" then
		for i, name in ipairs(frontWheels) do
			vehicle:resetComponentPosition(name)
			local x, y, z = vehicle:getComponentPosition(name)
			local offsetMul = 1 + offsetFront
			vehicle:setComponentPosition(name, x * offsetMul, y, z)
		end
	end
	-- Вынос задних колёс
	local offsetRear = vehicle:getData("WheelsOffsetR")
	if type(offsetRear) == "number" then
		for i, name in ipairs(rearWheels) do
			vehicle:resetComponentPosition(name)
			local x, y, z = vehicle:getComponentPosition(name)
			local offsetMul = 1 + offsetRear
			vehicle:setComponentPosition(name, x * offsetMul, y, z)
		end
	end
end

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	if name == "WheelsOffsetR" or name == "WheelsOffsetF" then
		updateVehicleConfiguration(source)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		updateVehicleConfiguration(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "vehicle" then
		updateVehicleConfiguration(source)
	end
end)