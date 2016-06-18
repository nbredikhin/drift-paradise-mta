addCommandHandler("a", function(player, cmd, ...)
	if not exports.dpUtils:isPlayerAdmin(player) then
		outputChatBox("Вы не являетесь администратором", player, 255, 0, 0)
		return 
	end
	local message = table.concat({...}, " ")
	triggerClientEvent("dpChat.message", resourceRoot, "adminsay", player, message)
end)