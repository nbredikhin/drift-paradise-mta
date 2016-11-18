--- Файл конфигурации бд
-- @script dpCore.DatabaseConfig
-- @author Wherry

--- Таблица конфигурации подключения к БД.
-- @tfield string dbType тип СУБД
-- @tfield string host хост
-- @tfield number port порт
-- @tfield string username имя пользователя
-- @tfield string password пароль
-- @tfield table options дополнительные параметры подключения
DatabaseConfig = {
	dbType = "mysql",

	host = "localhost", -- "database"
	port = 3306,
	dbName = "drift_paradise",

	-- Auth
	username = "root",
	password = "",

	options = {
		autoreconnect = 1		
	}
}