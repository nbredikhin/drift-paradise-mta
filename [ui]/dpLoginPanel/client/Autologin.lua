Autologin = {}

function Autologin.remember(username, password)
	local f
	if not fileExists("@autologin") then
		f = fileCreate("@autologin")
	else
		f = fileOpen("@autologin")
	end
	if not f then
		return
	end

	local fields = {}
	if username then
		fields.username = username
	end
	if password then
		fields.password = password
	end

	local jsonData = toJSON(fields)
	if not jsonData then
		return
	end
	fileWrite(f, jsonData)
	fileClose(f)
end

function Autologin.load()
	if not fileExists("@autologin") then
		return
	end
	local f = fileOpen("@autologin")
	if not f then
		return
	end
	local jsonData = fileRead(f, fileGetSize(f))
	fileClose(f)

	if not jsonData then
		return
	end
	local fields = fromJSON(jsonData)
	if not fields then
		return
	end
	return tostring(fields.username), tostring(fields.password)
end