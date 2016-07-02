--- Спавн игроков
-- @module dpCore.PlayerSpawn
-- @author Wherry

PlayerSpawn = {}

--- Заспавнить игрока.
-- Если у игрока нет дома, он будет заспавнен в отеле.
-- @tparam player player игрок, которого необходимо заспавнить
-- @treturn bool удалось ли заспавнить игрока
function PlayerSpawn.spawn(player)
	if not isElement(player) then
		return false
	end
	local location, isHotel = exports.dpHouses:getPlayerHouseLocation(player)
	if not isHotel then
		player:setData("activeMap", "house")
	end
	player:spawn(location.position)
	if location.rotation then
		player.rotation = location.rotation
	end
	player:setCameraTarget()
	player:fadeCamera(true, 3)
	player.interior = location.interior
	player.dimension = location.dimension
	player.model = player:getData("skin")
	triggerClientEvent("dpCore.spawn", player, isHotel)
	return true
end

addEventHandler("onPlayerWasted", root, function ()
	local player = source
	player:fadeCamera(false, 3)
	setTimer(function ()
		if isElement(player) then
			PlayerSpawn.spawn(player)
		end
	end, 3000, 1)
end)