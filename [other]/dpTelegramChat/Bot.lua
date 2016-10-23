Bot = {}

local API_URL = "https://api.telegram.org/bot%s/%s?%s"
local POLLING_INTERVAL = 2000

Bot.token = ""
local connected = false
local pollingTimer
local lastMessageDate = 0
local lastUpdateId = 0

function urlencode(str)
	if str then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
			function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str    
end	

local function updatePolling()
	Bot.callMethod("getUpdates", { offset = lastUpdateId, limit = 100 }, function (success, updates)
		if not success then
			return
		end
		if #updates == 0 then
			return
		end
		for i, update in ipairs(updates) do
			if tonumber(lastUpdateId) < tonumber(update.update_id) then
				lastUpdateId = tonumber(update.update_id)
				if tonumber(update.message.date) >= lastMessageDate then
					lastMessageDate = tonumber(update.message.date)				
					triggerEvent("Bot.message", resourceRoot, update.message)
				end
			end
		end
		--outputChatBox(tostring(data.update_id))
	end)
end

function Bot.connect(token)
	if type(token) ~= "string" then
		return false
	end
	if connected then
		outputDebugString("Error: bot is already connected")
		return false
	end
	Bot.token = token
	connected = true
	return Bot.callMethod("getMe", nil, function (success, data)
		if success then
			triggerEvent("Bot.connect", resourceRoot, data)
			pollingTimer = setTimer(updatePolling, POLLING_INTERVAL, 0)
			lastMessageDate = getRealTime().timestamp
		else
			connected = false
		end
	end)
end

function Bot.message(message)
	return Bot.callMethod("sendMessage", message)
end

function Bot.callMethod(methodName, params, callback)
	if type(methodName) ~= "string" then
		outputDebugString("Error: method name must be a string")
		return false
	end
	if params ~= nil and type(params) ~= "table" then
		outputDebugString("Error: params must be a table")
		return false
	end
	if not connected then
		outputDebugString("Error: bot is not connected")
		return false
	end
	if type(Bot.token) ~= "string" then
		outputDebugString("Error: bad token")
		return false
	end

	local paramsString = ""
		if params then
		for param, value in pairs(params) do
			paramsString = paramsString .. tostring(param) .. "=" .. tostring(value)
			if next(params, param) ~= nil then
				paramsString = paramsString .. "&"
			end
		end
		--paramsString = urlencode(paramsString)
	end

	local url = string.format(API_URL, Bot.token, methodName, paramsString)
	return fetchRemote(url, function (data, errorCode)
		-- TODO: Log here
		if type(callback) ~= "function" then
			return
		end
		if errorCode ~= 0 then
			callback(false, {})
			return
		end
		local data = fromJSON(data)
		if not data then
			callback(false, {})
			return
		end		
		callback(data.ok, data.result)
	end)
end