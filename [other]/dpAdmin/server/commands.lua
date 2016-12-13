local commands = {}

local function hasPlayerEnoughRights(player, requestedGroup)
	if not isElement(player) then
		return false
	end
	if not requestedGroup then
		return false
	end
	if isPlayerAdmin(player) then
		return true
	end
	local playerGroup = player:getData("group")
	if playerGroup == "admin" then
		return true
	end
	if playerGroup == "moderator" and requestedGroup == "moderator" then
		return true
	end
	return false
end

local function addCommand(name, group, handler)
	if type(name) ~= "string" or type(handler) ~= "function" then
		return false
	end
	if not group then
		group = "admin"
	end
	commands[name] = { handler = handler, group = group }
end

local function executeCommand(player, name, ...)
	if type(name) ~= "string" then
		return false
	end
	if type(commands[name]) ~= "table" then
		return false
	end
	if type(commands[name].handler) ~= "function" then
		return false
	end
	if not hasPlayerEnoughRights(player, commands[name].group) then
		return false
	end
	return commands[name].handler(player, ...)
end

addCommand("givemoney", "admin", function (admin, player, amount)
	return exports.dpCore:givePlayerMoney(player, amount)
end)

addCommand("givexp", "admin", function (admin, player, amount)
	return exports.dpCore:givePlayerXP(player, amount)
end)

addCommand("givecar", "admin", function (admin, player, name)
	local model = exports.dpShared:getVehicleModelFromName(name)
	if type(model) ~= "number" then
		return false
	end
	return exports.dpCore:addPlayerVehicle(player, model)
end)

addCommand("removecar", "admin", function (admin, player, id)
	return exports.dpCore:removePlayerVehicle(player, id)
end)

addCommand("settime", "admin", function (admin, hh, mm)
	return exports.dpTime:setServerTime(hh, mm)
end)

addCommand("kick", "moderator", function (admin, player, reason)
	return kickPlayer(player, admin, reason)
end)

addCommand("ban", "moderator", function (admin, player, duration, reason)
	triggerClientEvent("dpAdmin.showMessage", resourceRoot, "ban", admin, player)
	return exports.dpCore:banPlayer(player, duration, reason)
end)

addCommand("mute", "moderator", function (admin, player, duration)
	if exports.dpCore:mutePlayer(player, duration) then
		triggerClientEvent("dpAdmin.showMessage", resourceRoot, "mute", admin, player, duration)
	end
end)

addCommand("destroyCar", "moderator", function (admin, player)
	--return exports.dpCore:mutePlayer(player, duration)
end)

addEvent("dpAdmin.executeCommand", true)
addEventHandler("dpAdmin.executeCommand", root, function (commandName, ...)
	executeCommand(client, commandName, ...)
end)