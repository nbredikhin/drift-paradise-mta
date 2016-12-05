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

	host = "127.0.0.1", -- "database"
	port = 3306,
	dbName = "gs2554",

	-- Auth
	username = "gs2554",
	password = "SMeeXm2Wa5vGav",

	options = {
		autoreconnect = 1		
	}
}