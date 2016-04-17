function executeCallback(callback, ...)
	if type(callback) ~= "function" then
		return false
	end
	local success, err = pcall(callback, ...)
	if not success then
		outputDebugString("Error in callback: " .. tostring(err))
		return false
	end
	return true
end