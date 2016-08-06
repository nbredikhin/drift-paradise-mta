local function calculatePlayerLevel(player)
	if not isElement(player) then
		return false
	end
	local xp = player:getData("xp")
	if type(xp) ~= "number" then
		return false
	end
	local level = player:getData("level")
	if type(level) ~= "number" then
		return false
	end
	local newLevel = getLevelFromXP(xp)
	player:setData("level", newLevel)
	return true
end

addEvent("_playerDataLoaded", false)
addEventHandler("_playerDataLoaded", resourceRoot, function (player)
	calculatePlayerLevel(player)
end)

addEventHandler("onElementDataChange", root, function(dataName)
	if source.type == "player" and dataName == "xp" then		
		calculatePlayerLevel(source)
	end
end)