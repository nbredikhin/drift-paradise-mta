Bans = {}

local BANS_TABLE_NAME = "bans"
local BANS_REFRESH_INTERVAL = 5
local bansTable = {}
local allowedBanTypes = {
	mute = true,
	ban = true
}

function Bans.setup() 
	DatabaseTable.create(BANS_TABLE_NAME, {
		{ name="username", 		type="varchar", size=25, options="" },
		{ name="serial", 		type="varchar", size=64, options="" },
		-- Тип бана: "ban" или "mute"
		{ name="type",			type="varchar",	size=64, options="NOT NULL"},
		{ name="nickname",		type="varchar",	size=64 },
		{ name="reason",		type="MEDIUMTEXT" },
		{ name="ban_date", 		type="int", 	options="NOT NULL" },
		{ name="unban_date",	type="int", 	options="NOT NULL" },
	})

	setTimer(Bans.update, BANS_REFRESH_INTERVAL * 1000 * 60, 0)
	Bans.update()
end

local function getBan(banType, dataType, data)
	if not banType or not dataType or not data then
		return false
	end
	if not bansTable then
		return false
	end
	if not bansTable[banType] then
		return false
	end
	if not bansTable[banType][dataType] then
		return false
	end
	return bansTable[banType][dataType][data]
end

local function addBan(banInfo)
	if type(banInfo.type) ~= "string" then
		return
	end
	if not allowedBanTypes[banInfo.type] then
		outputDebugString("Invalid ban type")
		return
	end
	if not bansTable[banInfo.type] then
		bansTable[banInfo.type] = {}
	end

	local banData = { reason = banInfo.reason }

	if banInfo.username then
		if not bansTable[banInfo.type].username then
			bansTable[banInfo.type].username = {}
		end
		bansTable[banInfo.type].username[string.lower(banInfo.username)] = banData
	end
	if banInfo.serial then
		if not bansTable[banInfo.type].serial then
			bansTable[banInfo.type].serial = {}
		end
		bansTable[banInfo.type].serial[banInfo.serial] = banData
	end	
end	

local function removeBan(id)
	if not id then
		return false
	end
	DatabaseTable.delete(BANS_TABLE_NAME, { _id = id }, function (result)
		if result then
			outputDebugString("Ban removed: " .. tostring(id))
		end
	end)
end

function Bans.isSerialBanned(serial)
	if type(serial) ~= "string" then
		return false
	end	
	local banData = getBan("ban", "serial", serial)
	if banData then
		return true, banData.reason
	end
	return false
end

function Bans.isUserBanned(username)
	if type(username) ~= "string" then
		return false
	end
	username = string.lower(username)
	local banData = getBan("ban", "username", username)
	if banData then
		return true, banData.reason
	end
	return false	
end

function Bans.isPlayerMuted(player)
	if not isElement(player) then
		return false
	end
	if getBan("mute", "serial", player.serial) then
		return true
	end	
	local username = player:getData("username")
	if username and getBan("mute", "username", username) then
		return true
	end
	return false
end

function Bans.banPlayer(player, duration, reason)
	if not isElement(player) then
		outputDebugString("Bans: Failed to ban player. Bad player element")
		return false
	end
	if type(duration) ~= "number" then
		outputDebugString("Bans: Failed to ban player. Invalid duration '" .. tostring(duration) .. "'")
		return false
	end	
	local username = player:getData("username")
	return DatabaseTable.insert(BANS_TABLE_NAME, { 
		username 	= username, 
		nickname 	= player.name,
		serial 		= player.serial,
		reason 		= reason,
		unban_date 	= getRealTime().timestamp + duration,
		ban_date	= getRealTime().timestamp,
		type 		= "ban"
	}, function (result)
		if result then
			local reasonText = "You have been banned."
			if reason then
				reasonText = reasonText .. " Reason: " .. tostring(reason)
			end
			kickPlayer(player, reasonText)
			Bans.update()
		end
	end)
end

function Bans.mutePlayer(player, duration)
	if not isElement(player) then
		outputDebugString("Bans: Failed to mute player. Bad player element")
		return false
	end
	if Bans.isPlayerMuted(player) then
		outputDebugString("Bans: Failed to mute player. Player is already muted")
		return false
	end
	if type(duration) ~= "number" then
		outputDebugString("Bans: Failed to mute player. Invalid duration '" .. tostring(duration) .. "'")
		return false
	end	
	local username = player:getData("username")
	return DatabaseTable.insert(BANS_TABLE_NAME, { 
		username 	= username, 
		nickname 	= player.name,
		serial 		= player.serial,
		reason 		= reason,
		unban_date 	= getRealTime().timestamp + duration,
		ban_date	= getRealTime().timestamp,
		type 		= "mute"
	}, function (result)
		if result then
			Bans.update()
		end
	end)
end

function Bans.update()
	DatabaseTable.select(BANS_TABLE_NAME, {}, {}, function (result)
		if not result then 
			return
		end

		bansTable = {}
		
		local timestamp = getRealTime().timestamp
		for i, banInfo in ipairs(result) do
			if timestamp >= banInfo.unban_date then
				removeBan(banInfo._id)
			else
				addBan(banInfo)
			end
		end

		for i, player in ipairs(getElementsByType("player")) do
			player:setData("isMuted", Bans.isPlayerMuted(player))
		end
	end)
end

addEventHandler("onPlayerConnect", root, function (nickname, ip, username, serial)
	local isBanned, banReason = Bans.isSerialBanned(serial)
	if isBanned then
		local banMessage = ""
		if banReason then
			banMessage = "You are banned. Reason: " .. tostring(banReason)
		else
			banMessage = "You are banned from this server."
		end
		cancelEvent(true, banMessage)
	end
end)

addCommandHandler("updatebans", function(player, cmd, count)
	if not exports.dpUtils:isPlayerAdmin(player) then
		return
	end
	Bans.update()
	outputConsole("Updating bans list...")
	outputServerLog("Updating bans list...")
end)