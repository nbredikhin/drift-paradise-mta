PlayerData = {}
local dataFields = {
	"username", "skin", "money", "lastseen"
}

function PlayerData.set(player, account)
	for i, name in ipairs(dataFields) do
		player:setData(name, account[name])
	end
end

function PlayerData.get(player)
	local fields = {}
	for i, name in ipairs(dataFields) do
		fields[name] = player:getData(name)
	end	
	return fields
end

function PlayerData.clear(player)
	for i, name in ipairs(dataFields) do
		player:setData(name, nil)
	end
end

-- Защита даты 
addEventHandler("onElementDataChange", root, function(dataName, oldValue)
	if not client then
		return
	end
	if source.type == "player" then
		for i, name in ipairs(dataFields) do
			if dataName == name then
				source:setData(dataName, oldValue)
				return 
			end
		end
	end
end)