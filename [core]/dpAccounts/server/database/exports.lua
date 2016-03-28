-- Создание таблицы
-- string tableName, table columns, [...]
-- Columns: {name="string", type="varchar", size=255, options="NOT NULL PRIMARY"}
function createTable(...)
	return DatabaseTable.create(...)
end

-- Вставка в таблицу
-- string tableName, table insertValues, [...]
-- insertValues: Таблица {ключ=значение}
function insert(...)
	return DatabaseTable.insert(...)
end

-- Обновление записей в таблице
-- string tableName, table setFields, table whereFields, [...]
-- setFields: {key=value}
-- whereFields: {key=value}
function update(...)
	return DatabaseTable.update(...)
end

-- Получение записей из таблицы
-- string tableName, [table columns, ...]
-- columns: Массив {"column1", "column2", ...}
function select(...)
	return DatabaseTable.select(...)
end

function delete(...)
	outputDebugString("Not implemented yet")
	return false
end