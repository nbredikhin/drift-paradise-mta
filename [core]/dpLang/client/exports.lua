function setLanguage(...)
	success, result = pcall(Language.setLanguage, ...)
	if success then 
		return result
	else
		return false
	end
end

function getLanguage(...)
	success, result = pcall(Language.getLanguage, ...)
	if success then 
		return result
	else
		return false
	end
end

function getString(...)
	success, result = pcall(Language.getString, ...)
	if success then 
		return result
	else
		return false
	end
end

function chatMessage(...)
	success, result = pcall(Language.chatMessage, ...)
	if success then 
		return result
	else
		return false
	end	
end

function getAllStrings(...)
	success, result = pcall(Language.getAllStrings, ...)
	if success then 
		return result
	else
		return false
	end	
end