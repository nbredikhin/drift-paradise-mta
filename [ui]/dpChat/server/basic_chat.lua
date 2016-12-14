local languageChats = {
	UA = "ru",
	RU = "ru",
	BY = "ru"
}

addEvent("dpChat.broadcastMessage", true)
addEventHandler("dpChat.broadcastMessage", root, function (tabName, rawMessage)
	local sender
	if not client then
		sender = source
	else
		sender = client
	end

	if sender.muted then
		return
	end
	if sender:getData("isMuted") then
		return
	end

	exports.dpLogger:log("chat", string.format("[%s] %s (%s): %s",
		tostring(tabName),
		tostring(sender.name),
		tostring(sender:getData("username")),
		tostring(rawMessage)))
	
	triggerEvent("dpChat.message", resourceRoot, sender, tabName, rawMessage)
	if tabName == "global" then
		triggerClientEvent("dpChat.broadcastMessage", root, tabName, rawMessage, sender)
	elseif tabName == "web" then
		triggerClientEvent("dpChat.broadcastMessage", root, tabName, rawMessage, sender)
	elseif tabName == "lang" then
		local lang = sender:getData("langChat")
		if not lang then
			lang = "en"
		end
		for i, player in ipairs(getElementsByType("player")) do
			local playerLang = player:getData("langChat")
			if not playerLang then
				playerLang = "Unknown"
			end
			if playerLang == lang then
				triggerClientEvent(player, "dpChat.broadcastMessage", root, tabName, rawMessage, sender)
			end
		end
	elseif tabName == "local" then
		for i, player in ipairs(getElementsByType("player")) do
			local distance = (player.position - sender.position):getLength()
			if distance < 100 then
				triggerClientEvent(player, "dpChat.broadcastMessage", root, tabName, rawMessage, sender, nil, distance)
			end
		end
	end
end)

addEvent("dpChat.me", true)
addEventHandler("dpChat.me", root, function (tabName, rawMessage)
	local sender
	if not client then
		sender = source
	else
		sender = client
	end

	if tabName == "local" then
		for i, player in ipairs(getElementsByType("player")) do
			local distance = (player.position - sender.position):getLength()
			if distance < 100 then
				triggerClientEvent(player, "dpChat.me", root, tabName, rawMessage, sender, distance)
			end
		end
	else
		triggerClientEvent("dpChat.me", root, tabName, rawMessage, sender)
	end
end)

local function setupPlayerCountry(player)
	if not code then
		return
	end
	local name = "en"
	if languageChats[code] then
		name = languageChats[code]
	end
	player:setData("langChat", name)
	player:setData("country", code)
end

addEventHandler("onPlayerJoin", root, function ()
	setupPlayerCountry(source)
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, p in ipairs(getElementsByType("player")) do
		setupPlayerCountry(p)
	end
end)

addEventHandler("onPlayerChat", root, function (message, messageType)
	cancelEvent()
	if messageType == 0 then
		triggerClientEvent(source, "dpChat.message", source, "global", message)
	elseif messageType == 1 then
		triggerClientEvent(source, "dpChat.command", source, "global", "me", message)
	end
end)

function message(element, tabName, message)
	triggerClientEvent(element, "dpChat.serverMessage", root, tabName, message)
end
