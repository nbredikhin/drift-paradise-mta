-- Result event:
-- dpAccounts.registerResponse
function register(username, password)
	if 	not exports.dpUtils:argcheck(username, "string") or 
		not exports.dpUtils:argcheck(password, "string")
	then
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
	triggerServerEvent("dpAccounts.registerRequest", resourceRoot, username, password)
	return true
end

-- Result event:
-- dpAccounts.loginResponse
function login(username, password)
	if 	not exports.dpUtils:argcheck(username, "string") or 
		not exports.dpUtils:argcheck(password, "string")
	then
		return false
	end
	if AccountsConfig.HASH_PASSWORDS_CLIENTSIDE then
		password = sha256(password)
	end
	triggerServerEvent("dpAccounts.loginRequest", resourceRoot, username, password)
	return true
end

-- Result event:
-- dpAccounts.loginResponse
function logout()
	triggerServerEvent("dpAccounts.logoutRequest", resourceRoot)
	return true
end