function isPlayerAdmin(player)
	local account = getPlayerAccount(player)
	return isObjectInACLGroup("user." .. getAccountName(account), aclGetGroup("Admin"))
end
