Sessions = {} 
local authorizedUsers = {}

function Sessions.start(username, account)
	if authorizedUsers[username] then
		return false
	end
	authorizedUsers[username] = true
	outputChatBox("User authorized: " .. tostring(username))
end