-- Result event:
-- dpCore.registerResponse
function register(username, password, ...)
	if type(username) ~= "string" or type(password) ~= "string" then
		return false
	end	
	local success, errorType = checkUsername(username)
	if not success then
		return false, errorType
	end
	success, errorType = checkPassword(password)
	if not success then
		return false, errorType
	end	
	if AccountsConfig.HASH_PASSWORDS_CLIENTSIDE then
		password = sha256(password)
	end
	triggerServerEvent("dpCore.registerRequest", resourceRoot, username, password, ...)
	return true
end

-- Result event:
-- dpCore.loginResponse
function login(username, password)
	if type(username) ~= "string" or type(password) ~= "string" then
		return false
	end
	if AccountsConfig.HASH_PASSWORDS_CLIENTSIDE then
		password = sha256(password)
	end
	triggerServerEvent("dpCore.loginRequest", resourceRoot, username, password)
	return true
end

-- Result event:
-- dpCore.loginResponse
function logout()
	triggerServerEvent("dpCore.logoutRequest", resourceRoot)
	return true
end