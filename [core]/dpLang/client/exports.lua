function set(language)
	return Config.setProperty("ui.language", language)
end
setLanguage = set

function get(...)
	success, result = pcall(Language.get, ...)
	if success then
		return result
	else
		return false
	end
end
getLanguage = get

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
