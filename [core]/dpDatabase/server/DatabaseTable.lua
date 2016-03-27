-- Модуль для работы с таблицами в базе данных
DatabaseTable = {}

local function returnQueryResults(queryHandle, ...)
	local result = queryHandle:poll(0)
	outputDebugString("Database query result: " .. tostring(result))
	-- TODO: triggerEvent
end

function DatabaseTable.create(name, columns, ...)
	if 	not exports.dpUtils:argcheck(name, "string") or 
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
	table.insert(columns, {name = "id", type = "int", options = "NOT NULL PRIMARY KEY AUTO_INCREMENT"})
	local columnsQueries = {}
	for i, column in ipairs(columns) do
		local columnQuery = connection:prepareString("`?` ??", column.name,  column.type)
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
		"CREATE TABLE ?? (" .. table.concat(columnsQueries, ", ") .. ");", 
		name
	)
	return connection:query(returnQueryResults, queryString, ...)
end

function DatabaseTable.insert()
	local connection = Database.getConnection()
	return true
end

function DatabaseTable.update()
	local connection = Database.getConnection()
	return true
end

function DatabaseTable.delete()
	local connection = Database.getConnection()
	return true
end

function DatabaseTable.select()
	local connection = Database.getConnection()
	return true
end

function DatabaseTable.selectJoin()
	local connection = Database.getConnection()
	return true
end