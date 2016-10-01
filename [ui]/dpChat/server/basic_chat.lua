local languageChats = {
	UA = "ru",
	RU = "ru",
	BY = "ru"
}

addEvent("dpChat.broadcastMessage", true)
addEventHandler("dpChat.broadcastMessage", root, function (tabName, rawMessage)
	local message = client.name .. "#FFFFFF: " .. tostring(rawMessage)
	if tabName == "global" then		
		triggerClientEvent("dpChat.broadcastMessage", root, "global", message, client)
	elseif tabName == "lang" then
		local lang = client:getData("langChat")
		if not lang then
			lang = "en"
		end
		for i, player in ipairs(getElementsByType("player")) do
			local playerLang = player:getData("langChat")
			if not playerLang then
				playerLang = "Unknown"
			end
			if playerLang == lang then
				triggerClientEvent(player, "dpChat.broadcastMessage", root, "lang", message, client)
			end
		end
	elseif tabName == "local" then
		for i, player in ipairs(getElementsByType("player")) do
			local distance = (player.position - client.position):getLength()
			if distance < 100 then
				triggerClientEvent(player, "dpChat.broadcastMessage", root, "local", rawMessage, client, distance)
			end
		end
	end
end)

addEvent("dpChat.me", true)
addEventHandler("dpChat.me", root, function (tabName, rawMessage)
	if tabName == "local" then
		for i, player in ipairs(getElementsByType("player")) do
			local distance = (player.position - client.position):getLength()
			if distance < 100 then
				triggerClientEvent(player, "dpChat.me", root, tabName, rawMessage, client, distance)
			end
		end
	else
		triggerClientEvent("dpChat.me", root, tabName, rawMessage, client)
	end
end)

local function setupPlayerCountry(player)
	local code = exports.geoip:getCountry(player.ip)
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