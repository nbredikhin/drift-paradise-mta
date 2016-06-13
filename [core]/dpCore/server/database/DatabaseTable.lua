--- Модуль для работы с таблицами в базе данных
-- @module dpCore.DatabaseTable
-- @author Wherry


-- Модуль для работы с таблицами в базе данных
DatabaseTable = {}
--- Название столбца для ID записи
DatabaseTable.ID_COLUMN_NAME = "_id"
--- Тип столбца для ID записи
DatabaseTable.ID_COLUMN_TYPE = "int"

local function retrieveQueryResults(connection, queryString, callback, ...)	
	if not isElement(connection) then
		outputDebugString("ERROR: retrieveQueryResults failed: no database connection")
		return false
	end
	if type(queryString) ~= "string" then
		error("queryString must be string")
	end
	-- Если не передали callback
	if type(callback) ~= "function" then
		local handle = connection:query(queryString)
		local result = handle:poll(-1)
		return result
	else -- Если передали callback
		return not not connection:query(function (queryHandle, args)
			local result = queryHandle:poll(0)
			if type(args) ~= "table" then
				args = {}
			end
			executeCallback(callback, result, unpack(args))
		end, {...}, queryString)
	end
end

--- Создание таблицы
-- @tparam string tableName название таблицы
-- @tparam table columns столбцы. См. пример
-- @tparam[opt] string options параметры таблицы
-- @treturn bool удалось ли создать таблицу
-- @usage DatabaseTable.create("users", {
--	{ name="username", type="varchar", size=25, options="UNIQUE NOT NULL" },
--	{ name="password", type="varchar", size=255, options="NOT NULL" },
--	{ name="money", type="bigint", options="UNSIGNED NOT NULL DEFAULT 0" },
--})
function DatabaseTable.create(tableName, columns, options)
	if type(tableName) ~= "string" or type(columns) ~= "table" then
		outputDebugString("ERROR: DatabaseTable.create: bad arguments")
		return false
	end
	if type(options) ~= "string" then
		options = ""
	else
		options = ", " .. options 
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.create: no database connection")
		return false
	end
	-- Автоматическое создание поля с id
	table.insert(columns, {name = DatabaseTable.ID_COLUMN_NAME, type = DatabaseTable.ID_COLUMN_TYPE, options = "NOT NULL PRIMARY KEY AUTO_INCREMENT"})
	-- Строка запроса для каждого столбца таблицы
	local columnsQueries = {}
	for i, column in ipairs(columns) do
		local columnQuery = connection:prepareString("`??` ??", column.name,  column.type)
		if column.size and tonumber(column.size) then
			columnQuery = columnQuery .. connection:prepareString("(??)", column.size)
		end
		if not column.options or type(column.options) ~= "string" then
			column.options = ""
		end
		if string.len(column.options) > 0 then
			columnQuery = columnQuery .. " " .. column.options
		end
		table.insert(columnsQueries, columnQuery)
	end
	local queryString = connection:prepareString(
		"CREATE TABLE IF NOT EXISTS `??` (" .. table.concat(columnsQueries, ", ") .. " " .. options .. ");", 
		tableName
	)
	return connection:exec(queryString)
end

--- Вставка в таблицу
-- @tparam string tableName название таблицы
-- @tparam table insertValues значения полей {ключ=значение}
-- @tparam[opt] function callback callback
-- @treturn bool результат выполнения функции
-- Если не указан callback, функция выполняется синхронно и результат запроса к БД будет передан в качестве возвращаемого значения.
-- @usage DatabaseTable.insert("users", { name = "User1", password = "12345" })
function DatabaseTable.insert(tableName, insertValues, callback, ...)
	if type(tableName) ~= "string" or type(insertValues) ~= "table" or not next(insertValues) then
		outputDebugString("ERROR: DatabaseTable.insert: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.insert: no database connection")
		return false
	end
	local columnsQueries = {}
	local valuesQueries = {}
	local valuesCount = 0
	for column, value in pairs(insertValues) do
		table.insert(columnsQueries, connection:prepareString("`??`", column))
		table.insert(valuesQueries, connection:prepareString("?", value))
		valuesCount = valuesCount + 1
	end
	if valuesCount == 0 then
		return retrieveQueryResults(connection, connection:prepareString("INSERT INTO `??`;", tableName), callback, ...)
	end
	local columnsQuery = connection:prepareString("(" .. table.concat(columnsQueries, ",") .. ")")
	local valuesQuery = connection:prepareString("(" .. table.concat(valuesQueries, ",") .. ")")
	local queryString = connection:prepareString(
		"INSERT INTO `??` " .. columnsQuery .. " VALUES " .. valuesQuery .. ";", 
		tableName
	)
	return retrieveQueryResults(connection, queryString, callback, ...)
end

--- Обновление записей в таблице
-- @tparam string tableName название таблицы
-- @tparam table setFields значения полей, которые нужно изменить {ключ=значение}
-- @tparam[opt] table whereFields поля, по которым будут выбираться строки {ключ=значение}
-- @tparam[opt] function callback callback
-- @treturn bool результат выполнения функции.
-- Если не указан callback, функция выполняется синхронно и результат запроса к БД будет передан в качестве возвращаемого значения.
-- @usage DatabaseTable.update("users", { password = "789" }, { username = "user1" })
function DatabaseTable.update(tableName, setFields, whereFields, callback, ...)
	if type(tableName) ~= "string" or type(setFields) ~= "table" or not next(setFields) or type(whereFields) ~= "table" then
		outputDebugString("ERROR: DatabaseTable.update: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.update: no database connection")
		return false
	end

	local setQueries = {}
	for column, value in pairs(setFields) do
		table.insert(setQueries, connection:prepareString("`??`=?", column, value))
	end
	local whereQueries = {}
	if not whereFields then
		whereFields = {}
	end
	for column, value in pairs(whereFields) do
		table.insert(whereQueries, connection:prepareString("`??`=?", column, value))
	end
	local queryString = connection:prepareString("UPDATE `??` SET " .. table.concat(setQueries, ", "), tableName)
	if #whereQueries > 0 then
		queryString = queryString .. connection:prepareString(" WHERE " .. table.concat(whereQueries, ", "))
	end
	queryString = queryString .. ";"
	return retrieveQueryResults(connection, queryString, callback, ...)
end

-- string tableName, [table columns, ...]
-- columns: Массив {"column1", "column2", ...}
-- Если не указаны columns, делается SELECT *

--- Получение записей из таблицы
-- @tparam string tableName название таблицы
-- @tparam table columnst список столбцов, которые нужно получить
-- @tparam[opt] table whereFields поля, по которым будут выбираться строки {ключ=значение}
-- @tparam[opt] function callback callback
-- @treturn bool результат выполнения функции. 
-- Если не указан callback, функция выполняется синхронно и результат запроса к БД будет передан в качестве возвращаемого значения.
-- @usage DatabaseTable.select("users", {"username", "password"}, { username = "user3" })
function DatabaseTable.select(tableName, columns, whereFields, callback, ...)
	if type(tableName) ~= "string" then
		outputDebugString("ERROR: DatabaseTable.select: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		outputDebugString("ERROR: DatabaseTable.select: no database connection")
		return false
	end
	-- WHERE
	local whereQueries = {}
	if not whereFields then
		whereFields = {}
	end
	for column, value in pairs(whereFields) do
		table.insert(whereQueries, connection:prepareString("`??`=?", column, value))
	end
	local whereQueryString = ""
	if #whereQueries > 0 then
		whereQueryString = " WHERE " .. table.concat(whereQueries, ", ")
	end

	-- COLUMNS
	-- SELECT *
	if not columns or type(columns) ~= "table" or #columns == 0 then
		return retrieveQueryResults(connection, connection:prepareString("SELECT * FROM `??` " .. whereQueryString ..";", tableName), callback, ...)
	end
	local selectColumns = {}
	for i, name in ipairs(columns) do
		table.insert(selectColumns, connection:prepareString("`??`", name))
	end
	
	-- SELECT COLUMNS
	local queryString = connection:prepareString(
		"SELECT " .. table.concat(selectColumns, ",") .." FROM `??` " .. whereQueryString ..";", 
		tableName
	)
	return retrieveQueryResults(connection, queryString, callback, ...)
end

--- Удаление записей из таблицы.
-- Данный метод не реализован
function DatabaseTable.delete()
	local connection = Database.getConnection()
	return true
end