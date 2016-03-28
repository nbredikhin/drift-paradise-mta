-- Основной модуль для работы с базой данных
Database = {}
local dbConnection

function Database.connect()
	if isElement(dbConnection) then
		exports.dpLog:warning("Database.connect: connection already exists")
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
		exports.dpLog:error("Database.connect: failed to connect")
		return false
	end
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
		exports.dpLog:warning("Database.disconnect: no connection")
		return false
	end
	dbConnection:destroy()
	dbConnection = nil
	return true
end