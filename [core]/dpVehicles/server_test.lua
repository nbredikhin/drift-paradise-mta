addCommandHandler("sc", function (player, cmd, name, value)
	if not name or not value then
		outputChatBox("SOSI PISOS")
		return
	end
	if not player.vehicle then
		outputChatBox("SOSI PISOS V AVTO SADIS")
		return 
	end
	player.vehicle:setData(name, tonumber(value))
	outputChatBox("SET " .. tostring(name) .. ": " .. tostring(value))
end)

local function toggleLights(player)
	if not player.vehicle then
		return false
	end
	player.vehicle:setData("LightsState", not not not player.vehicle:getData("LightsState"))
end

addEventHandler("onPlayerJoin", root, function ()
	bindKey(source, "1", "down", toggleLights)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, p in ipairs(getElementsByType("player")) do
		bindKey(p, "1", "down", toggleLights)
	end
end)