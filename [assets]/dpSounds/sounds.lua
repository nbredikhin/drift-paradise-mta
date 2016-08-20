function playSound(name, ...)
	if type(name) ~= "string" then
		return false
	end
	return Sound("sounds/" .. name, ...)
end