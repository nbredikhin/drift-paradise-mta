bindKey("x", "down", function() showCursor(true) end)
bindKey("x", "up", function() showCursor(false) end)

local state = false
local p1 = Vector3()
local p2 = Vector3()

local function strVector(v)
	return math.floor(v.x * 100) / 100 .. ", " .. math.floor(v.y * 100) / 100 .. ", " .. math.floor(v.z * 100) / 100
end
addEventHandler("onClientClick", root, function (button, s, _, _, x, y, z)
	if s ~= "down" then
		return false
	end
	if not state then
		p1 = Vector3(x, y, z)
	else
		p2 = Vector3(x, y, z)
		if button == "left" then
			outputChatBox("{ Vector3(" .. strVector(p1) .. "), Vector3(" .. strVector(p2) .. ") },", 0, 255, 0)
		end
	end
	state = not state
	if button ~= "left" then
		outputChatBox("Reset state", 255, 0, 0)
		state = false
	end
end)