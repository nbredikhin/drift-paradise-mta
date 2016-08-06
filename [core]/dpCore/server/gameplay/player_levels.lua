local function calculatePlayerLevel(player)
	if not isElement(player) or player.type ~= "player" then
		return false
	end
	player:setData("level", 1)
	return true
end

addEvent("_playerDataLoaded", false)
addEventHandler("_playerDataLoaded", resourceRoot, function (player)
	calculatePlayerLevel(player)
end)

addEventHandler("onElementDataChange", root, function(dataName)
	if source.type == "player" and dataName == "xp" then
		calculatePlayerLevel(player)
	end
end)