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