local languageChats = {
	UA = "ru",
	RU = "ru",
	BY = "ru"
}

addEvent("dpChat.broadcastMessage", true)
addEventHandler("dpChat.broadcastMessage", root, function (tabName, message)
	local message = client.name .. "#FFFFFF: " .. tostring(message)
	if tabName == "global" then		
		triggerClientEvent("dpChat.broadcastMessage", root, "global", message)
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
				triggerClientEvent(player, "dpChat.broadcastMessage", root, "lang", message)
			end
		end
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