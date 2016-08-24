Encrypter = {}
Encrypter.SECRET_KEY = "pososite_pisos_pozhaluista"
local ENCODE_PART = 0.15 -- < 0.5
local DELIM = "KEKNWGQNIOGWNIOGWQINOWQGNIOQWGNIOLEL"

function Encrypter.encode(data)
	local length = math.floor(string.len(data) * ENCODE_PART / 2)
	-- начало файла
	local part1 = base64Encode(string.sub(data, 1, length))
	part1 = teaEncode(part1, Encrypter.SECRET_KEY)
	data = string.sub(data, length + 1, -1)
	-- конец файла
	local part2 = base64Encode(string.sub(data, string.len(data) - length + 1, -1))
	part2 = teaEncode(part2, Encrypter.SECRET_KEY)
	data = string.sub(data, 1, string.len(data) - length)

	return table.concat({part2, part1, data}, DELIM)
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

function Encrypter.decode(data)
	local tokens = split(data, DELIM)
	local part2 = base64Decode(teaDecode(tokens[1], Encrypter.SECRET_KEY))
	local part1 = base64Decode(teaDecode(tokens[2], Encrypter.SECRET_KEY))
	local data = tokens[3]
	return string.format("%s%s%s", part1, data, part2)
end