Sessions = {} 
local authorizedUsers = {}

function Sessions.isActive(player)
	if not isElement(player) then
		return false
	end
	return not not authorizedUsers[player]
end

function Sessions.start(player)
	if not isElement(player) then
		return false
	end
	if Sessions.isActive(player) then
		return false
	end
	authorizedUsers[player] = true
	return true
end

function Sessions.stop(player)
	if not Sessions.isActive(player) then
		return false
	end
	authorizedUsers[player] = nil
	return true
end