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

	host = "127.0.0.1",
	port = 3306,
	dbName = "mta_server_dev",

	-- Auth
	username = "root",
	password = "",

	options = {
		autoreconnect = 1		
	}
}