Users = {}
local DB_TABLE_NAME = "users"
local DB_PASSWORD_SECRET = "test"

function Users.setup()
	DatabaseTable.create(DB_TABLE_NAME, {
		{ name="username", type="varchar", size=25, options="UNIQUE" },
		{ name="password", type="varchar", size=255 }
	}, function (result)
		outputDebugString("Users table already created")
	end)
end

local function hashUserPassword(username, password)
	return sha256(password .. tostring(username) .. tostring(string.len(username)) .. tostring(DB_PASSWORD_SECRET))
end

function Users.registerPlayer(player, username, password, callback)
	if 	not exports.dpUtils:argcheck(player, "player") or
		not exports.dpUtils:argcheck(username, "string") or 
		not exports.dpUtils:argcheck(password, "string")
	then	
		exorts.dpLog:error("Users.registerPlayer: bad arguments")
		return false
	end
	-- Проверка имени пользователя и пароля
	if not checkUsername(username) or not checkPassword(password) then
		exorts.dpLog:error("Users.registerPlayer: bad username or password")
		return false
	end
	-- Хэширование пароля
	password = hashUserPassword(username, password)
	-- Добавление пользователя в базу
	DatabaseTable.insert(DB_TABLE_NAME, {
		username = username,
		password = password
	}, callback)
	return true
end

function Users.loginPlayer(player, username, password, callback)
	if 	not exports.dpUtils:argcheck(player, "player") or
		not exports.dpUtils:argcheck(username, "string") or 
		not exports.dpUtils:argcheck(password, "string")
	then	
		exorts.dpLog:error("Users.registerPlayer: bad arguments")
		return false
	end
	outputDebugString("Callback: " .. tostring(callback))
	-- Получение пользователя из базы
	DatabaseTable.select(DB_TABLE_NAME, nil, function(result)
		local success = false
		local errorType = ""
		if result then
			success = true
		end
		if success then
			password = hashUserPassword(username, password)
			-- Проверка пароля
			if password == result[1].password then
				-- Запустить сессию
				success = Sessions.start(username, result[1])
				if not success then
					errorType = "already_logged_in"
				end
			else
				success = false
				errorType = "incorrect_password"
			end		
		end
		if callback and type(callback) == "function" then
			callback(success, errorType)
		end
	end)
	return true
end

addEvent("dpAccounts.register", true)
addEventHandler("dpAccounts.register", resourceRoot, function(username, password)
	local player = client
	local success = Users.registerPlayer(player, username, password, function(result)
		if result then
			result = true
		end
		triggerClientEvent(player, "dpAccounts.register", resourceRoot, result)
	end)
	if not success then
		triggerClientEvent(player, "dpAccounts.register", resourceRoot, false)
	end
end)

addEvent("dpAccounts.login", true)
addEventHandler("dpAccounts.login", resourceRoot, function(username, password)
	local player = client
	local success = Users.loginPlayer(player, username, password, function(result, errorType)
		triggerClientEvent(player, "dpAccounts.login", resourceRoot, result, errorType)
	end)
	if not success then
		triggerClientEvent(player, "dpAccounts.login", resourceRoot, false)
	end
end)