WebAPI.registerMethod("users.get", function (username)
	if not isDonationsAPIAvailable() then
		return "Donations not available"
	end
	if type(username) ~= "string" then
		return "Invalid username"
	end
	-- Получение профиля пользователя
	local user = exports.dpCore:getUserAccount(username)
	if not user then
		return "User not found"
	end
	-- Вернуть только некоторые поля
	return {
		id 			= user._id,
		username 	= user.username,
		money 		= user.money
	}
end)