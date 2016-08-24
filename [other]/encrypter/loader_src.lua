local function loadFile(path, count)
	local file = fileOpen(path)
	if not file then
		return false
	end
	if not count then
		count = fileGetSize(file)
	end
	local data = fileRead(file, count)
	fileClose(file)
	return data
end

local function split(str, delim)
	local tokens = {}
	local pos = string.find(str, delim)
	while pos do
		table.insert(tokens, string.sub(str, 1, pos - 1))
		str = string.sub(str, pos + string.len(delim), -1)
		pos = string.find(str, delim)
	end
	if string.len(str) > 0 then
		table.insert(tokens, str)
	end
	return tokens
end
function a(b)
	local data = loadFile(b.data)
	if not data then
		return false
	end
	local tokens = split(data, "KEKNWGQNIOGWNIOGWQINOWQGNIOQWGNIOLEL")
	local part2 = base64Decode(teaDecode(tokens[1], SUS))
	local part1 = base64Decode(teaDecode(tokens[2], SUS))
	local data = tokens[3]
	local huita = string.format("%s%s%s", part1, data, part2)

	if b.type == "dff" then
		engineReplaceModel (engineLoadDFF(huita), MODEL)
	elseif b.type == "txd" then
		engineImportTXD(engineLoadTXD(huita), MODEL)
	end
end

addEventHandler("onClientResourceStart",resourceRoot,function()
	for e,b in ipairs(DUNNO_WAT)do 
		if b.type=="txd"then 
			a(b)
		end 
	end;

	for e,b in ipairs(DUNNO_WAT)do 
		if b.type=="dff"then 
			a(b)
		end 
	end;

	for e,b in ipairs(DUNNO_WAT)do 
		if b.type~="dff"and b.type~="txd"then 
			a(b)
		end
	end 
end)
