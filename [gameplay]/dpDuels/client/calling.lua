-- Вызов игроков на дуэль (клиент)

-- Вызвать игрока на дуэль
-- player - игрок
-- bet - ставка
function callPlayer(player)
	InviteWindow.show(player)
end

-- addCommandHandler("duel", function ()
-- 	local player = getElementsByType("player")[1]
-- 	if player == localPlayer then
-- 		player = getElementsByType("player")[2]
-- 	end
	
-- 	DuelUI.show(player)
-- end)