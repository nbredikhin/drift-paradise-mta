-- Модуль для работы с таблицами в базе данных
DatabaseTable = {}

local function returnQueryResults(queryHandle, ...)
	local result = queryHandle:poll(0)
	outputDebugString("Database query result: " .. tostring(result))
	-- TODO: triggerEvent
end

function DatabaseTable.create(tableName, columns, ...)
	if 	not exports.dpUtils:argcheck(tableName, "string") or 
		not exports.dpUtils:argcheck(columns, "table")
	then
		exports.dpLog:error("DatabaseTable.create: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		exports.dpLog:error("DatabaseTable.create: no database connection")
		return false
	end
	-- Автоматическое создание поля с id
	table.insert(columns, {name = "id", type = "int", options = "NOT NULL PRIMARY KEY AUTO_INCREMENT"})
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
		"CREATE TABLE `??` (" .. table.concat(columnsQueries, ", ") .. ");", 
		tableName
	)
	return connection:query(returnQueryResults, queryString, ...)
end

function DatabaseTable.insert(tableName, insertValues, ...)
	if 	not exports.dpUtils:argcheck(tableName, "string") or 
		not exports.dpUtils:argcheck(insertValues, "table", {notEmpty = true})
	then
		exports.dpLog:error("DatabaseTable.insert: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		exports.dpLog:error("DatabaseTable.insert: no database connection")
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
		return connection:query(returnQueryResults, connection:prepareString("INSERT INTO `??`;"), ...)
	end
	local columnsQuery = connection:prepareString("(" .. table.concat(columnsQueries, ",") .. ")")
	local valuesQuery = connection:prepareString("(" .. table.concat(valuesQueries, ",") .. ")")
	local queryString = connection:prepareString(
		"INSERT INTO `??` " .. columnsQuery .. " VALUES " .. valuesQuery .. ";", 
		tableName
	)
	return connection:query(returnQueryResults, queryString, ...)
end

function DatabaseTable.update(tableName, setFields, whereFields, ...)
	if 	not exports.dpUtils:argcheck(tableName, "string") or 
		not exports.dpUtils:argcheck(setFields, "table", {notEmpty = true}) or
		not exports.dpUtils:argcheck(whereFields, "table", {notEmpty = true})
	then
		exports.dpLog:error("DatabaseTable.update: bad arguments")
		return false
	end
	local connection = Database.getConnection()
	if not connection then
		exports.dpLog:error("DatabaseTable.update: no database connection")
		return false
	end

	local setQueries = {}
	for column, value in pairs(setFields) do
		table.insert(setQueries, connection:prepareString("`??`=?", column, value))
	end
	local updateQueries = {}
	for column, value in pairs(whereFields) do
		table.insert(updateQueries, connection:prepareString("`??`=?", column, value))
	end
	outputDebugString(queryString)
	local queryString = connection:prepareString(
		"UPDATE `??` SET " .. table.concat(setQueries, ", ") .. " WHERE " .. table.concat(updateQueries, ", ") .. ";", 
		tableName
	)
	return connection:query(returnQueryResults, queryString, ...)
end

function DatabaseTable.delete()
	local connection = Database.getConnection()
	return true
end

function DatabaseTable.select()
	local connection = Database.getConnection()
	return true
end