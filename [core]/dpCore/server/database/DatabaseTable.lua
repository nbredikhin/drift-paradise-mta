-- Модуль для работы с таблицами в базе данных
DatabaseTable = {}
DatabaseTable.ID_COLUMN_NAME = "_id"
DatabaseTable.ID_COLUMN_TYPE = "int"

local function createQueryCallback(callback)
	return function(queryHandle, ...)
		local result = queryHandle:poll(0)
		--outputDebugString("Database query result: " .. tostring(result))
		triggerEvent("dpDatabase.queryResult", root, queryHandle, result, ...)
		executeCallback(callback, result, ...)
	end
end

-- Создание таблицы
-- string tableName, table columns, [...]
-- Columns: {name="string", type="varchar", size=255, options="NOT NULL PRIMARY"}
function DatabaseTable.create(tableName, columns, options, callback, ...)
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
		"CREATE TABLE `??` (" .. table.concat(columnsQueries, ", ") .. " " .. options .. ");", 
		tableName
	)
	return not not connection:query(createQueryCallback(callback), queryString, ...)
end

-- Вставка в таблицу
-- string tableName, table insertValues, [...]
-- insertValues: Таблица {ключ=значение}
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
		return not not connection:query(createQueryCallback(callback), connection:prepareString("INSERT INTO `??`;", tableName), ...)
	end
	local columnsQuery = connection:prepareString("(" .. table.concat(columnsQueries, ",") .. ")")
	local valuesQuery = connection:prepareString("(" .. table.concat(valuesQueries, ",") .. ")")
	local queryString = connection:prepareString(
		"INSERT INTO `??` " .. columnsQuery .. " VALUES " .. valuesQuery .. ";", 
		tableName
	)
	return not not connection:query(createQueryCallback(callback), queryString, ...)
end

-- Обновление записей в таблице
-- string tableName, table setFields, table whereFields, [...]
-- setFields: {key=value}
-- whereFields: {key=value}
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
	for column, value in pairs(whereFields) do
		table.insert(whereQueries, connection:prepareString("`??`=?", column, value))
	end
	local queryString = connection:prepareString("UPDATE `??` SET " .. table.concat(setQueries, ", "), tableName)
	if #whereQueries > 0 then
		queryString = queryString .. connection:prepareString(" WHERE " .. table.concat(whereQueries, ", "))
	end
	queryString = queryString .. ";"
	return not not connection:query(createQueryCallback(callback), queryString, ...)
end

-- Получение записей из таблицы
-- string tableName, [table columns, ...]
-- columns: Массив {"column1", "column2", ...}
-- Если не указаны columns, делается SELECT *
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
		return not not connection:query(createQueryCallback(callback), connection:prepareString("SELECT * FROM `??` " .. whereQueryString ..";", tableName), ...)
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
	return not not connection:query(createQueryCallback(callback), queryString, ...)
end

-- TODO
function DatabaseTable.delete()
	local connection = Database.getConnection()
	return true
end