-- Основной модуль для работы с базой данных
Database = {}
local dbConnection

function Database.connect()
	if isElement(dbConnection) then
		outputDebugString("WARNING: Database.connect: connection already exists")
		return false
	end

	local host = DatabaseUtils.prepareDatabaseOptionsString {
		host = DatabaseConfig.host,
		port = DatabaseConfig.port,
		dbname = DatabaseConfig.dbName
	}
	local options = DatabaseUtils.prepareDatabaseOptionsString(DatabaseConfig.options)	
	dbConnection = Connection(
		DatabaseConfig.dbType,
		host,
		DatabaseConfig.username,
		DatabaseConfig.password,
		options
	)
	if not dbConnection then
		outputDebugString("ERROR: Database.connect: failed to connect")
		root:setData("dbConnected", false)
		return false
	end
	root:setData("dbConnected", true)
	return true
end

function Database.getConnection()
	if not isElement(dbConnection) then
		dbConnection = nil
	end
	return dbConnection
end

function Database.disconnect()
	if not isElement(dbConnection) then
		outputDebugString("WARNING: Database.disconnect: no connection")
		return false
	end
	dbConnection:destroy()
	dbConnection = nil
	return true
end