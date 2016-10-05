function isPlayerAdmin(player)
	if not isElement(player) or not player.account then
		return false
	end
	if player.account.guest then
		return false
	end
	local adminGroup = ACLGroup.get("Admin")
	if not adminGroup then
		return false
	end
	return not not adminGroup:doesContainObject("user." .. tostring(player.account.name))
end