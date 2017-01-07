Users = {}
-- Время автосохранения в минутах
local AUTOSAVE_INTERVAL = 5
local USERS_TABLE_NAME = "users"
local PASSWORD_SECRET = "oijqwgi912hon3gf8h0q1n9n01f1"
local BETA_KEY_CHECK_ENABLED = false

function Users.setup()
    DatabaseTable.create(USERS_TABLE_NAME, {
        { name="username", type="varchar", size=25, options="UNIQUE NOT NULL" },
        { name="password", type="varchar", size=255, options="NOT NULL" },
        -- Онлайн ли игрок
        { name="online", type="bool", options="DEFAULT 0" },
        -- Деньги
        { name="money", type="bigint", options="UNSIGNED NOT NULL DEFAULT 0" },
        -- Количество минут, проведённых в игре
        { name="playtime", type="int", options="UNSIGNED NOT NULL DEFAULT 0" },
        -- Скин
        { name="skin", type="smallint", options="UNSIGNED NOT NULL DEFAULT 0" },
        -- Дата регистрации
        { name="register_time", type="timestamp", options="DEFAULT CURRENT_TIMESTAMP" },
        -- Дата последней активности
        { name="lastseen", type="int", options="DEFAULT 0" },
        -- День, до которого активен премиум
        { name="premium_expires",  type="int", options="DEFAULT 0" },
        -- XP
        { name="xp", type="bigint", options="UNSIGNED NOT NULL DEFAULT 0" },
        -- Группа
        { name="group", type="varchar", size=25 }
    })
    -- Очистка даты
    for i, player in ipairs(getElementsByType("player")) do
        PlayerData.clear(player)
    end

    logoutOfflineUsers()
end

-- Функция хэширования паролей пользователей
local function hashUserPassword(username, password)
    return sha256(password .. tostring(username) .. tostring(string.len(username)) .. tostring(PASSWORD_SECRET))
end

-- Проверка пароля, повторного входа и т. д.
local function verifyLogin(player, username, password, account)
    if  type(player)    ~= "userdata" or
        type(username)  ~= "string" or
        type(password)  ~= "string" or
        type(account)   ~= "table"
    then
        outputDebugString("ERROR: verifyLogin: User not found")
        return false, "user_not_found"
    end
    -- Проверка повторного входа
    if tonumber(account.online) > 0 then
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

    exports.dpLogger:log("auth", string.format("New user registered: '%s'", username))
    return true
end

function Users.loginPlayer(player, username, password, callback)
    if not isElement(player) or type(username) ~= "string" or type(password) ~= "string" then
        outputDebugString("ERROR: Users.registerPlayer: bad arguments")
        return false
    end

    -- Если игрок забанен
    if Bans.isUserBanned(username) then
        outputDebugString("ERROR: Users.loginPlayer: User is banned")
        return false, "account_banned"
    end
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
                exports.dpLogger:log("auth", string.format("User '%s' logged in with nickname '%s'", username, tostring(player.name)))
                DatabaseTable.update(USERS_TABLE_NAME, {online=SERVER_ID}, {username=username})
                PlayerData.set(player, account)

                -- Количество автомобилей игрока
                UserVehicles.getVehiclesIds(account._id, function (result)
                    if type(result) == "table" then
                        player:setData("garage_cars_count", #result)
                    end
                end)
            else
                errorType = "already_logged_in"
            end
        else
            executeCallback(callback, success, errorType)
            return
        end
        executeCallback(callback, success, errorType)
    end)
end

function Users.updateUserPassword(username, password, callback)
    if type(username) ~= "string" or type(password) ~= "string" then
        outputDebugString("ERROR: Users.updateUserPassword: bad arguments")
        return false
    end

    -- Проверка пароля
    if not checkPassword(password) then
        outputDebugString("ERROR: Users.updateUserPassword: bad password")
        return false, "bad_password"
    end
    -- Хэширование пароля
    password = hashUserPassword(username, password)
    exports.dpLogger:log("auth", string.format("User '%s' changed password", username))
    -- Обновление пароля
    return DatabaseTable.update(USERS_TABLE_NAME, { password = password }, { username = username }, callback)
end

function Users.get(userId, fields, callback)
    if type(userId) ~= "number" or type(fields) ~= "table" then
        executeCallback(callback, false)
        return false
    end

    return DatabaseTable.select(USERS_TABLE_NAME, fields, { _id = userId }, callback)
end

function Users.update(username, fields)
    if type(username) ~= "string" or type(fields) ~= "table" then
        return false
    end
    return DatabaseTable.update(USERS_TABLE_NAME, fields, {username = username}, function () end)
end

function Users.getByUsername(username, fields, callback)
    if type(username) ~= "string" or type(fields) ~= "table" then
        return false
    end

    return DatabaseTable.select(USERS_TABLE_NAME, fields, { username = username }, callback)
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

    local playerName = player.name
    local username = player:getData("username")
    exports.dpLogger:log("auth", string.format("User '%s' has logged out (%s)", username, tostring(player.name)))
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
    return DatabaseTable.update(USERS_TABLE_NAME, fields, {username = username})
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

function Users.getPlayerByUsername(username)
    if type(username) ~= "string" then
        return false
    end
    for i, player in ipairs(getElementsByType("player")) do
        local name = player:getData("username")
        if name and name == username then
            return player
        end
    end
    return false
end

addEvent("dpCore.registerRequest", true)
addEventHandler("dpCore.registerRequest", resourceRoot, function(username, password, betaKey)
    local player = client

    -- Проверка ключа
    if BETA_KEY_CHECK_ENABLED then
        if not BetaKeys.isKeyValid(betaKey) then
            triggerClientEvent(player, "dpCore.registerResponse", resourceRoot, false, "beta_key_invalid")
            triggerEvent("dpCore.register", player, false, "beta_key_invalid")
            return
        end
    end

    local success, errorType = Users.registerPlayer(player, username, password, function(result)
        result = not not result
        local errorType = ""
        if not result then
            errorType = "username_taken"
        else
            if BETA_KEY_CHECK_ENABLED then
                BetaKeys.activateKey(betaKey)
            end
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

addEvent("dpCore.passwordChangeRequest", true)
addEventHandler("dpCore.passwordChangeRequest", resourceRoot, function (password)
    local player = client

    if not Users.isPlayerLoggedIn(player) then
        triggerClientEvent(player, "dpCore.passwordChangeResponse", resourceRoot, false)
        return false
    end
    local username = player:getData("username")
    local success = Users.updateUserPassword(username, password, function (result)
        triggerClientEvent(player, "dpCore.passwordChangeResponse", resourceRoot, result)
    end)
    if not success then
        triggerClientEvent(player, "dpCore.passwordChangeResponse", resourceRoot, false)
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

function logoutOfflineUsers()
    return DatabaseTable.select(USERS_TABLE_NAME, { "username" }, { online = SERVER_ID }, function (result)
        local count = 0
        if not result then
            return
        end
        for i, user in ipairs(result) do
            local player = Users.getPlayerByUsername(user.username)
            if not player then
                DatabaseTable.update(USERS_TABLE_NAME, {online=0}, {username=user.username}, function()end)
                count = count + 1
            end
        end
        if count > 0 then
            outputDebugString("Logged out " .. tostring(count) .. " user(s)")
        end
    end)
end

local function checkPlayerPremium(player)
    if not isElement(player) then
        return
    end
    local premiumExpireDate = player:getData("premium_expires")
    if type(premiumExpireDate) ~= "number" then
        player:setData("isPremium", false)
        player:setData("premium_expires", 0)
        return
    end

    if premiumExpireDate < getRealTime().timestamp then
        player:setData("isPremium", false)
        player:setData("premium_expires", 0)
        outputDebugString("Premium expired for " .. tostring(player.name))
        return
    end
end

setTimer(function ()
    for i, player in ipairs(getElementsByType("player")) do
        if player:getData("isPremium") then
            checkPlayerPremium(player)
        end
        Users.saveAccount(player)
    end

    logoutOfflineUsers()
    exports.dpLogger:log("auth", "Autosave completed")
end, AUTOSAVE_INTERVAL * 60 * 1000, 0)
