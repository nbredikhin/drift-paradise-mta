addEvent("dpChat.pm", true)
addEventHandler("dpChat.pm", root, function(targetPlayer, message)
	triggerClientEvent(targetPlayer, "dpChat.pm", root, client, message)
end)