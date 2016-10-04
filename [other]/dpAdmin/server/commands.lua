local commands = {}

local function addCommand(name, handler)
	if type(name) ~= "string" or type(handler) ~= "function" then
		return false
	end
	commands[name] = handler
end

local function executeCommand(player, name, ...)
	if type(name) ~= "string" then
		return false
	end
	if type(commands[name]) ~= "function" then
		return false
	end
	-- TODO: Check is player admin
	return commands[name](...)
end

addCommand("givemoney", function (player, amount)
	return exports.dpCore:givePlayerMoney(player, amount)
end)

addCommand("givexp", function (player, amount)
	return exports.dpCore:givePlayerXP(player, amount)
end)

addCommand("givecar", function (player, name)
	local model = exports.dpShared:getVehicleModelFromName(name)
	if type(model) ~= "number" then
		return false
	end
	return exports.dpCore:addPlayerVehicle(player, model)
end)

addEvent("dpAdmin.executeCommand", true)
addEventHandler("dpAdmin.executeCommand", resourceRoot, function (commandName, ...)
	executeCommand(client, commandName, ...)
end)