Users = {}
local USERS_TABLE_NAME = "users"
local PASSWORD_SECRET = "s9abBUIg090j21aASGzc90avj1l"

function Users.setup()
	DatabaseTable.create(USERS_TABLE_NAME, {
		{ name="username", type="varchar", size=25, options="UNIQUE NOT NULL" },
		{ name="password", type="varchar", size=255, options="NOT NULL" },
		{ name="online", type="bool", options="DEFAULT 0" },
		{ name="money", type="bigint", options="UNSIGNED NOT NULL DEFAULT 0" },
		{ name="skin", type="smallint", options="UNSIGNED NOT NULL DEFAULT 0" },
		{ name="lastseen", type="timestamp", options="NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }
	}, function (result)
		if not result then
			outputDebugString("Users table already exists")
		end
	end)
	-- Очистка информации о входе
	DatabaseTable.update(USERS_TABLE_NAME, {online=0}, {})
	-- Очистка даты
	for i, player in ipairs(getElementsByType("player")) do
		PlayerData.clear(player)
	end
end

-- Функция хэширования паролей пользователей
local function hashUserPassword(username, password)
	return sha256(password .. tostring(username) .. tostring(string.len(username)) .. tostring(PASSWORD_SECRET))
end

-- Проверка пароля, повторного входа и т. д.
local function verifyLogin(player, username, password, account)
	if 	type(player) 	~= "userdata" or 
		type(username) 	~= "string" or 
		type(password) 	~= "string" or 
		type(account) 	~= "table" 
	then
		outputDebugString("ERROR: verifyLogin: User not found")
		return false, "user_not_found"
	end
	-- Проверка повторного входа
	if tonumber(account.online) == 1 then
		outputDebugString("ERROR: verifyLogin: User already logged in")
		return false, "already_logged_in"
	end
	-- Проверка правильности пароля
	password = hashUserPassword(username, password)
	if password ~= account.password then
		outputDebugString("ERROR: verifyLogin: Incorrect password")
		return false, "incorrect_password"
	end
	return true
end

function Users.registerPlayer(player, username, password, callback)
	if not isElement(player) or type(username) ~= "string" or type(password) ~= "string" then	
		outputDebugString("ERROR: Users.registerPlayer: bad arguments")
		return false
	end
	username = string.lower(username)
	-- Проверка имени пользователя и пароля
	if not checkUsername(username) or not checkPassword(password) then
		outputDebugString("ERROR: Users.registerPlayer: bad username or password")
		return false, "bad_password"
	end
	-- Хэширование пароля
	password = hashUserPassword(username, password)
	-- Добавление пользователя в базу
	DatabaseTable.insert(USERS_TABLE_NAME, {
		username = username,
		password = password
	}, callback)
	return true
end

function Users.loginPlayer(player, username, password, callback)
	if not isElement(player) or type(username) ~= "string" or type(password) ~= "string" then
		outputDebugString("ERROR: Users.registerPlayer: bad arguments")
		return false
	end
	username = string.lower(username)

	-- Если игрок уже залогинен
	if Sessions.isActive(player) then
		outputDebugString("ERROR: Users.loginPlayer: User already logged in")
		return false, "already_logged_in"
	end
	-- Получение пользователя из базы
	return DatabaseTable.select(USERS_TABLE_NAME, {}, { username = username }, function(result)
		local success, errorType = not not result, "user_not_found"
		local account
		-- Проверка пароля и т. д.
		if result then
			account = result[1]
			success, errorType = verifyLogin(player, username, password, account)
		end
		if success then
			-- Запустить сессию
			success = Sessions.start(player)
			if success then					
				DatabaseTable.update(USERS_TABLE_NAME, {online=1}, {username=username})
				PlayerData.set(player, account)
			else
				errorType = "already_logged_in"
			end
		end
		-- Вызывать callback
		if type(callback) == "function" then
			callback(success, errorType)
		end
	end)
end

function Users.get(userId, fields, callback)
	if type(userId) ~= "number" or type(fields) ~= "table" then
		executeCallback(callback, false)
		return false
	end
	
	return DatabaseTable.select(USERS_TABLE_NAME, fields, { _id = userId }, callback)
end

function Users.isPlayerLoggedIn(player)
	return Sessions.isActive(player)
end

function Users.logoutPlayer(player, callback)
	if not isElement(player) then
		return false
	end
	if not Sessions.isActive(player) then
		return false
	end	
	Users.saveAccount(player)
	Sessions.stop(player)

	local username = player:getData("username")
	return DatabaseTable.update(USERS_TABLE_NAME, {online=0}, {username=username}, function(result)
		if type(callback) == "function" then
			callback(not not result)
		end
	end)
end

function Users.saveAccount(player)
	if not isElement(player) then
		return false
	end
	if not Sessions.isActive(player) then
		return false
	end
	local username = player:getData("username")
	local fields = PlayerData.get(player)
	outputDebugString(tostring(fields))
	DatabaseTable.update(USERS_TABLE_NAME, fields, {username = username})
	return true
end

function Users.getPlayerById(id)
	if not id then
		return false
	end
	for i, player in ipairs(getElementsByType("player")) do
		local playerId = player:getData("_id") 
		if playerId and playerId == id then
			return player
		end
	end
	return false
end

addEvent("dpCore.registerRequest", true)
addEventHandler("dpCore.registerRequest", resourceRoot, function(username, password)
	local player = client
	local success, errorType = Users.registerPlayer(player, username, password, function(result)
		result = not not result
		local errorType = ""
		if not result then
			errorType = "username_taken"
		end
		triggerClientEvent(player, "dpCore.registerResponse", resourceRoot, result, errorType)
		triggerEvent("dpCore.register", player, result, errorType)
	end)
	if not success then
		triggerClientEvent(player, "dpCore.registerResponse", resourceRoot, false)
		triggerEvent("dpCore.register", player, false, errorType)
	end
end)

addEvent("dpCore.loginRequest", true)
addEventHandler("dpCore.loginRequest", resourceRoot, function(username, password)
	local player = client
	local success, errorType = Users.loginPlayer(player, username, password, function(result, errorType)
		triggerClientEvent(player, "dpCore.loginResponse", resourceRoot, result, errorType)
		triggerEvent("dpCore.login", player, result, errorType)
	end)
	if not success then
		triggerClientEvent(player, "dpCore.loginResponse", resourceRoot, false, errorType)
		triggerEvent("dpCore.login", player, false, errorType)
	end
end)

addEvent("dpCore.logoutRequest", true)
addEventHandler("dpCore.logoutRequest", resourceRoot, function(username, password)
	local player = client
	local success = Users.logoutPlayer(player, function(result)
		triggerClientEvent(player, "dpCore.logoutResponse", resourceRoot, result)
		triggerEvent("dpCore.logout", player, result)
	end)
	if not success then
		triggerClientEvent(player, "dpCore.logoutResponse", resourceRoot, false)
		triggerEvent("dpCore.logout", player, false)
	end
end)

addEventHandler("onPlayerQuit", root, function ()
	Users.logoutPlayer(source)
end)

addEventHandler("onResourceStop", resourceRoot, function ()
	for i, player in ipairs(getElementsByType("player")) do
		Users.logoutPlayer(player)
	end
end)