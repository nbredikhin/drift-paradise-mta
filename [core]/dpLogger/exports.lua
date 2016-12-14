-- Вывод в лог
-- log ( logFile, message [, forceDebug ] )

-- log("auth", "Hello World")
-- log("auth", "Test", true) - выводит в лог и в debugscript
function log(...)
	return Logger.log(...)
end

-- Включает/выключает вывод в debugscript для определенного лог-файла
-- debug("auth", true)
function debug(...)
	return Logger.setDebugMode(...)
end