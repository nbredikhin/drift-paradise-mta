-- Result event:
-- dpAccounts.register
function register(username, password)
	if 	not exports.dpUtils:argcheck(username, "string") or 
		not exports.dpUtils:argcheck(password, "string")
	then
		return false
	end	
	--password = sha256(password)
	triggerServerEvent("dpAccounts.registerRequest", resourceRoot, username, password)
	return true
end

-- Result event:
-- dpAccounts.login
function login(username, password)
	if 	not exports.dpUtils:argcheck(username, "string") or 
		not exports.dpUtils:argcheck(password, "string")
	then
		return false
	end
	--password = sha256(password)
	triggerServerEvent("dpAccounts.loginRequest", resourceRoot, username, password)
	return true
end