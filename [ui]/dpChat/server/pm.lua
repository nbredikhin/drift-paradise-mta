addEvent("dpChat.pm", true)
addEventHandler("dpChat.pm", root, function(targetPlayer, message)
	triggerClientEvent(targetPlayer, "dpChat.pm", root, client, message)
	exports.dpLogger:log("pm", string.format(
		"%s -> %s: %s", 
		client.name, 
		targetPlayer.name, 
		message))
end)