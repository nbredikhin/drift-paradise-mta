Logger = {}
local LOGS_PATH = "logs/"
local loadedLogs = {}
local debugLogs = {}

local function getLogFile(logName)
	if type(logName) ~= "string" then
		outputDebugString("Logger: bad log file name '" .. tostring(logName) .. "'")
		return false
	end
	if loadedLogs[logName] then
		return loadedLogs[logName]
	end

	local filePath = LOGS_PATH .. logName .. ".log"
	local file
	if not fileExists(filePath) then
		file = fileCreate(filePath)
	else
		file = fileOpen(filePath)
	end
	if not file then
		outputDebugString("Logger: failed to load log file: '" .. tostring(filePath) .. "'")
		return false
	end

	file.pos = file.size
	loadedLogs[logName] = file
	return file
end

local function formatTimeNumber(number)
	if number < 10 then
		return "0" .. tostring(number)
	end
	return tostring(number)
end

local function formatLogMessage(message)
	local time = getRealTime()
	return string.format("[%s-%s-%s %s:%s:%s] %s\n",
		tostring(1900 + time.year),
		formatTimeNumber(time.month),
		formatTimeNumber(time.monthday),
		formatTimeNumber(time.hour),
		formatTimeNumber(time.minute),
		formatTimeNumber(time.second),
		tostring(message))
end

local function appendLogMessage(logName, message)
	local file = getLogFile(logName)
	if not file then
		outputDebugString("Logger: failed to append log message. No .log file")
		return false
	end
	file:write(formatLogMessage(message))
	file:flush()
	return true
end

function Logger.setDebugMode(logName, enabled)
	if type(logName) ~= "string" then
		return false
	end
	if enabled then
		debugLogs[logName] = true
	else
		debugLogs[logName] = nil
	end
	return true
end

function Logger.log(logName, message, forceDebug)
	appendLogMessage(logName, message)
	if debugLogs[logName] or forceDebug then
		outputDebugString("[" .. tostring(logName) .. "] " .. tostring(message))
	end
end