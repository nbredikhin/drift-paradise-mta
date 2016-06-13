--- Система ключей для бета-теста
-- @module dpCore.BetaKeys
-- @author Wherry

BetaKeys = {}
local keysList = {}
local KEYS_FILE_PATH = "beta_keys.json"

function BetaKeys.start()
	local keysFile 
	if fileExists(KEYS_FILE_PATH) then
		keysFile = fileOpen(KEYS_FILE_PATH)
	else
		keysFile = fileCreate(KEYS_FILE_PATH)
	end
	if not keysFile then
		keysList = {}
		BetaKeys.save()
		return
	end
	local keysJSON = fileRead(keysFile, keysFile.size)
	keysList = fromJSON(keysJSON)
	fileClose(keysFile)
	if type(keysList) ~= "table" then
		keysList = {}
	end
	BetaKeys.save()
end

function BetaKeys.save()
	local keysFile 
	if fileExists(KEYS_FILE_PATH) then
		keysFile = fileOpen(KEYS_FILE_PATH)
	else
		keysFile = fileCreate(KEYS_FILE_PATH)
	end
	local keysJSON = toJSON(keysList)
	fileSetPos(keysFile, 0)
	for i = 1, keysFile.size do
		fileWrite(keysFile, " ")
	end
	fileSetPos(keysFile, 0)
	fileWrite(keysFile, keysJSON)
	fileClose(keysFile)
end

addEventHandler("onResourceStop", resourceRoot, function ()
	BetaKeys.save()
end)

function BetaKeys.activateKey(key)	
	local isValid, index = BetaKeys.isKeyValid(key)
	if not isValid then
		return false
	end
	table.remove(keysList, index)
	BetaKeys.save()
	return true
end

function BetaKeys.isKeyValid(key)
	if type(key) ~= "string" then
		return false
	end
	key = string.upper(key)
	key = key:gsub("%s+", "")
	for i, k in ipairs(keysList) do
		if k == key then
			return true, i
		end
	end
	return false
end

function BetaKeys.generateKey()
	local str = base64Encode(tostring(getRealTime().timestamp) .. ";" .. tostring(math.random(1, 100)) .. ";" .. tostring(getTickCount()))
	local key = string.sub(md5(teaEncode(str, "dp_beta")), 1, 5)
	table.insert(keysList, key)
	BetaKeys.save()
	return key
end

addCommandHandler("bolwepidorov", function(player, cmd, count)
	count = tonumber(count)
	if not count then
		count = 1
	end

	for i = 1, count do
		outputChatBox(tostring(BetaKeys.generateKey()), player)
	end
end)