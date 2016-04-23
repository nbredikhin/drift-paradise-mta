	-------------------------------------
	-- Вход и выход игроков из тюнинга --
	-------------------------------------

-- Отключение проверок перед входом в тюнинг
local DEBUG_DISABLE_OWNER_CHECK = true
local DEBUG_DISABLE_LOGGED_CHECK = true

function forcePlayerEnterTuning(player)
	if 	not isElement(player) or
		player:getData("state") or
		-- Проверка автомобиля
		not player.vehicle or 
		player.vehicle.controller ~= player or 
		exports.dpUtils:getVehicleOccupantsCount(vehicle) > 1 
	then
		if isElement(player) then
			triggerClientEvent(player, "dpTuning.serverEnter", resourceRoot, false)
		end
		return false
	end
	-- Проверка авторизации
	if not DEBUG_DISABLE_LOGGED_CHECK then
		if not player:getData("username") then
			triggerClientEvent(player, "dpTuning.serverEnter", resourceRoot, false, "tuning_not_logged_in")
			return false
		end
	end
	-- Проверка, является ли игрок владельцем автомобиля
	if not DEBUG_DISABLE_OWNER_CHECK then
		if  not player.vehicle:getData("owner_username") or
			player.vehicle:getData("owner_username") ~= player:getData("username") 
		then
			triggerClientEvent(player, "dpTuning.serverEnter", resourceRoot, false, "tuning_not_owner")
			return false
		end 
	end
	-- Вход в тюнинг
	player:setData("state", "tuning")
	local dimension = (player:getData("_id") or math.random(0, 1000)) + 6000
	player.dimension = dimension
	player.vehicle.dimension = dimension
	triggerClientEvent(player, "dpTuning.serverEnter", resourceRoot, true)
	return true
end

function forcePlayerExitTuning(player)
	if not isElement(player) then
		return false
	end
	if player:getData("state") ~= "tuning" then
		return false
	end
	player:setData("state", false)
	player.dimension = 0
	player.vehicle.dimension = 0
	triggerClientEvent(player, "dpTuning.serverExit", resourceRoot)
	return true
end

addEvent("dpTuning.clientEnter", true)
addEventHandler("dpTuning.clientEnter", resourceRoot, function ()
	forcePlayerEnterTuning(client)
end)

addEvent("dpTuning.clientExit", true)
addEventHandler("dpTuning.clientExit", resourceRoot, function ()
	if not forcePlayerExitTuning(client) then
		triggerClientEvent(player, "dpTuning.serverExit", resourceRoot)
	end
end)

-- addEventHandler("onResourceStop", resourceRoot, function ()
-- 	for i, player in ipairs(getElementsByType("player")) do
-- 		forcePlayerExitTuning(player)
-- 	end
-- end)