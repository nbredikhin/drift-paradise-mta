--- Синхронизация конфигурации автомобилей (вынос колёс, подвеска)
-- @script dpVehicles.configuration

local frontWheels = {"wheel_lf_dummy", "wheel_rf_dummy"}
local rearWheels = {"wheel_lb_dummy", "wheel_rb_dummy"}

local WHEELS_OFFSET_MAX = 0.23

local function updateVehicleWheelsOffset(vehicle)
	-- Вынос передних колёс
	local offsetFront = vehicle:getData("WheelsOffsetF")
	if type(offsetFront) == "number" then
		for i, name in ipairs(frontWheels) do
			if not vehicle:getComponentPosition(name) then
				return false
			end
			vehicle:resetComponentPosition(name)
			local x, y, z = vehicle:getComponentPosition(name)
			local offsetMul = 1 + offsetFront * WHEELS_OFFSET_MAX
			vehicle:setComponentPosition(name, x * offsetMul, y, z)
		end
	end
	-- Вынос задних колёс
	local offsetRear = vehicle:getData("WheelsOffsetR")
	if type(offsetRear) == "number" then
		for i, name in ipairs(rearWheels) do
			if not vehicle:getComponentPosition(name) then
				return false
			end			
			vehicle:resetComponentPosition(name)
			local x, y, z = vehicle:getComponentPosition(name)
			local offsetMul = 1 + offsetRear * WHEELS_OFFSET_MAX
			vehicle:setComponentPosition(name, x * offsetMul, y, z)
		end
	end
	return true
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
	local status = updateVehicleConfiguration(vehicle)

	if not status then
		-- Обновить колёса по таймеру
		local updateTimer = setTimer(function()
			if isElement(vehicle) then
				-- Вынос
				local status = updateVehicleWheelsOffset(vehicle)
				if status and isTimer(updateTimer) then				
					killTimer(updateTimer)
				end
			elseif isTimer(updateTimer) then
				killTimer(updateTimer)
			end
		end, 300, 0)
	end
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