PlayerData = {}
local loadFields = {
	"_id", "username", "skin", "money", "lastseen"
}
local saveFields = {
	"skin", "money"
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
	end
end)