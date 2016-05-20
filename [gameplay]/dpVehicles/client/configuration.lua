local frontWheels = {"wheel_lf_dummy", "wheel_rf_dummy"}
local rearWheels = {"wheel_lb_dummy", "wheel_rb_dummy"}

local function updateVehicleWheelsOffset(vehicle)
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

local function updateVehicleConfiguration(vehicle)
	-- Обновить вынос
	updateVehicleWheelsOffset(vehicle)
	-- Обновить подвеску
	-- TODO:
	-- Обновить развал
	-- TODO:
	-- Обновить размер колёс
	-- TODO:
end

-- Костыль ибаный
local function updateConfigurationWithTimer(vehicle)
	-- Обновить конфигурацию
	updateVehicleConfiguration(vehicle)

	-- Обновить колёса по таймеру
	local updateTimer = setTimer(function()
		if isElement(vehicle) then
			-- Вынос
			updateVehicleWheelsOffset(vehicle)
		elseif isTimer(updateTimer) then
			killTimer(updateTimer)
		end
	end, 100, 15)
end

addEventHandler("onClientElementDataChange", root, function (name, oldVaue)
	if source.type ~= "vehicle" then
		return
	end
	if name == "WheelsOffsetR" or name == "WheelsOffsetF" then
		updateConfigurationWithTimer(source)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		updateVehicleConfiguration(vehicle)
	end
end)

addEventHandler("onClientElementStreamIn", root, function ()
	if source.type == "vehicle" then
		updateConfigurationWithTimer(source)
	end
end)