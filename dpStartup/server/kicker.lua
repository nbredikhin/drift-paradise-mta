addEvent("selfKick", true)
addEventHandler("selfKick", root, function (reason)
	local reasonText
	if reason == "afk" then
		reasonText = "You are AFK"
	end
	kickPlayer(client, reasonText)
end)