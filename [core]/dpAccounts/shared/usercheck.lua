local USERNAME_MIN_LENGTH = 3
local USERNAME_MAX_LENGTH = 25
local USERNAME_REGEXP = "^[a-zA-Z0-9](_(?!(\.|_))|\.(?!(_|\.))|[a-zA-Z0-9]){3,25}[a-zA-Z0-9]$"

local PASSWORD_MIN_LENGTH = 3
local PASSWORD_MAX_LENGTH = 32

local function checkStringLength(str, min, max)
	local len = string.len(str)
	if len < min then
		return false, "too_short"
	elseif len > max then
		return false, "too_long"
	end
	return true
end

-- Проверка имени пользователя
function checkUsername(username)
	local success, err = checkStringLength(username, USERNAME_MIN_LENGTH, USERNAME_MAX_LENGTH)
	if not success then
		return false, err
	end
	if not pregFind(username, USERNAME_REGEXP) then
		return false, "invalid"
	end
	return true
end

-- Проверка пароля
function checkPassword(password)
	local success, err = checkStringLength(password, PASSWORD_MIN_LENGTH, PASSWORD_MAX_LENGTH)
	if not success then
		return false, err
	end	
	return true
end