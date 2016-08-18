# dpUtils
В данном ресурсе содержатся полезные функции, применяемые в остальных ресурсах.

## Время (shared/time.lua)
__isLeapYear__(_number_ year) - проверяет, является ли високосным год year.

__getTimestamp__(year, month, day, hour, minute, second) - возвращает UNIX timestamp

__convertTimestampToSeconds__(str) - преобразование timestamp'а из формата MySQL в формат UNIX timestamp

## Геометрия (shared/geom.lua)
__wrapAngle__(_number_ value) - разворачивает угол, чтобы он лежал в интервале от -180 до 180.

__wrapAngleRadians__(_number_ value) - разворачивает угол в радианах, чтобы он лежал в интервале от -pi до pi.

__differenceBetweenAngles__(_number_ firstAngle, _number_ secondAngle) - минимальное расстояние между углами. Например, для углов 360 и 1 эта функция вернёт 1.

__differenceBetweenAnglesRadians__(_number_ firstAngle, secondAngle) - расстояние между углами в радианах.

## Таблицы (shared/table.lua)
__tableCopy__(_table_ orig) - возвращает копию таблицы orig (копирует не рекурсивно).

__extendTable__(_table_ table1, _table_ table2) - дополняет отсутствующие поля в table1 (поля, значения которых равны nil) полями из table2.

## Транспорт (shared/vehicles.lua)
__isValidVehicleModel__(_number_ model) - является модель model реальной моделью транспорта GTA.

__getVehicleOccupantsCount__(_element_ vehicle) - возвращает количество пассажиров автомобиля.

## Прочее (shared/other.lua)
__defaultValue__(value, default) - возвращает default, если value равно nil.

__capitalizeString__(_string_ str) - возвращает строку, начинающуюся с заглавной буквы.

__clearChat__ - очищает чат.

__isResourceRunning__(_string_ name) - запущен ли ресурс с названием name.

__removeHexFromString__(_string_ str) - удаляет все hex-коды из строки str.

__RGBToHex__(red, green, blue, alpha) - получает hex-код цвета из RGB.

__generateString__(_number_ len) - генерирует случайную строку длины len.

__getPlayersByPartOfName__(_string_ namePart, _bool_ caseSensitive) - возвращает массив игроков, найденных по части имени namePart.

__getElementDataDefault__(element, dataName, defaultValue) - возвращает дату элемента или defaultValue, если она nil.

__format_num__(amount, decimal, prefix, neg_prefix) - форматирование для валюты.