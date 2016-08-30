local DONATIONS_KEY = "CHANGE_ME_PLEASE"

local function checkDonationsKey(key)
	if type(key) ~= "string" then
		return "No key provided"
	end
	-- Проверка секретного ключа
	if key ~= DONATIONS_KEY then
		return "Invalid key"
	end
	return nil
end

WebAPI.registerMethod("donations.buyMoney", function (key, username, money)
	local err = checkDonationsKey(key)
	if err then return err end
	if type(username) ~= "string" then
		return "Invalid username"
	end
	local money = tonumber(money)
	if type(money) ~= "number" then
		return "Bad money amount"
	end
	money = math.floor(money)

	-- Проверка пользователя
	username = string.lower(username)
	if not exports.dpCore:userExists(username) then
		return "User not found"
	end
	-- Зачисление денег
	local player = exports.dpCore:getUserPlayer(username)
	-- Если игрок на сервере
	if isElement(player) then
		WebAPI.log("Player is online. Giving money to player")
		if not exports.dpCore:givePlayerMoney(player, money) then
			return "Failed to give player money"
		end
	else
		WebAPI.log("Player is offline. Giving money to account")
		local userAccount = exports.dpCore:getUserAccount(username)
		if type(userAccount) ~= "table" then
			return "User account not found"
		end
		local userMoney = userAccount.money
		if type(userMoney) ~= "number" then
			WebAPI.log("User account has no money field")
			return "Bad user account"
		end
		local result = exports.dpCore:updateUserAccount(username, {
			["money"] = userMoney + money
		})
		if not result then
			WebAPI.log("Unexpected error")
			return "Failed to give user money"
		end
	end
	return true
end)