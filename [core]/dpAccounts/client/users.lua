-- Result event:
-- dpAccounts.register
function register(username, password)
	if 	not exports.dpUtils:argcheck(username, "string") or 
		not exports.dpUtils:argcheck(password, "string")
	then
		return false
	end	
	--password = sha256(password)
	triggerServerEvent("dpAccounts.register", resourceRoot, username, password)
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
	triggerServerEvent("dpAccounts.login", resourceRoot, username, password)
	return true
end