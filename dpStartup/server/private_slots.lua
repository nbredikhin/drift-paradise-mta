local PRIVATE_SLOTS_COUNT = 1
local serialsList = {}

local function reloadSerials()
	serialsList = {}
	local file = fileOpen("serials.json")
	if not file then
		return false
	end
	local data = file:read(file.size)
	file:close()

	if not data then
		return false
	end
	serialsList = fromJSON(data)
	if type(serialsList) ~= "table" or #serialsList == 0 then
		serialsList = {}
		return false
	end
	return true
end

local function isSerialReserved(serial)
	for i, reservedSerial in ipairs(serialsList) do
		if reservedSerial == serial then
			return true
		end
	end
	return false
end

addEventHandler("onPlayerConnect", root, function (nickname, ip, username, serial)
	if getMaxPlayers() - getPlayerCount() <= PRIVATE_SLOTS_COUNT then
		if not isSerialReserved(serial) then
			cancelEvent(true, "The server is full / Сервер заполнен")
		end
	end
end)

setTimer(reloadSerials, 300000, 0)
reloadSerials()