local players = {}

addEventHandler("onPlayerJoin", root, function ()
	if #players == 0 then
		players[1] = source
		source.id =  "player_1"
		source:setData("serverId", 1)
		return
	end
	for i = 1, #players + 1 do
		if not isElement(players[i]) then
			players[i] = source
			source.id =  "player_" .. tostring(i)
			source:setData("serverId", i)
			return
		end
	end
 end)

addEventHandler("onPlayerQuit", root, function ()
	local id = tonumber(source.id)
	if id then
		players[id] = nil
	end
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	players = getElementsByType("player")
	for i, p in ipairs(players) do
		p.id = "player_" .. tostring(i)
		p:setData("serverId", i)
	end
end)