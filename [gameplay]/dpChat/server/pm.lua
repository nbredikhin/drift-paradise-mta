addCommandHandler("pm", function(senderPlayer, cmd, target, ...)
	if not target then
		outputChatBox("/pm <id> <text>", senderPlayer, 255, 0, 0)
		return
	end
	local targetPlayer = exports.dpUtils:getPlayersByPartOfName(target)[1]
	if not isElement(targetPlayer) then
		targetPlayer = getElementByID(target)
		if not isElement(targetPlayer) then
			outputChatBox("Игрок не найден", senderPlayer, 255, 0, 0)
			return
		end
	end
	if targetPlayer == senderPlayer then
		outputChatBox("Нельзя отправить PM самому себе", senderPlayer, 255, 0, 0)
		return
	end
	local message = table.concat({...}, " ")
	local senderName = exports.dpUtils:removeHexFromString(senderPlayer.name)
	local targetName = exports.dpUtils:removeHexFromString(targetPlayer.name)
	outputChatBox("[PM] To " .. senderName .. ": " .. message, targetPlayer, 255, 0, 0, true)
	outputChatBox("[PM] From " .. senderName .. ": " .. message, targetPlayer, 255, 0, 0, true)
end)