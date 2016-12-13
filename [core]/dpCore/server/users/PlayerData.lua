PlayerData = {}
local loadFields = {
	"_id", "username", "skin", "money", "lastseen", "playtime", "register_time", "xp", "group"
}
local saveFields = {
	"skin", "money", "playtime", "xp"
}
local protectFields = {
	"house_id", "level", "money", "xp", "group"
}

local function filterData(dataName, value)
	if dataName == "lastseen" then
		return exports.dpUtils:convertTimestampToSeconds(value)
	end
	return value
end

function PlayerData.set(player, account)
	for i, name in ipairs(loadFields) do
		player:setData(name, filterData(name, account[name]))
	end
	player:setData("level", 1)
	triggerEvent("_playerDataLoaded", resourceRoot, player)
end

function PlayerData.get(player)
	local fields = {}
	for i, name in ipairs(saveFields) do
		fields[name] = player:getData(name)
	end
	return fields
end

function PlayerData.clear(player)
	for i, name in ipairs(loadFields) do
		player:setData(name, nil)
	end
	player:setData("dpCore.state", nil)
end

-- Защита даты 
addEventHandler("onElementDataChange", root, function(dataName, oldValue)
	if not client then
		return
	end
	if source.type == "player" then
		for i, name in ipairs(loadFields) do
			if dataName == name then
				source:setData(dataName, oldValue)
				return 
			end
		end
		for i, name in ipairs(protectFields) do
			if dataName == name then
				source:setData(dataName, oldValue)
				return 
			end
		end		
	end
end)

setTimer(function()
	for i, player in ipairs(getElementsByType("player")) do
		local currentPlaytime = tonumber(player:getData("playtime"))
		if currentPlaytime then
			player:setData("playtime", currentPlaytime + 1)
		end
	end
end, 60000, 0)