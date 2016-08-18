-- https://wiki.multitheftauto.com/wiki/IsLeapYear
-- This function checks if a year is a leap year or not.
function isLeapYear(year)
	if year then year = math.floor(year)
	else year = getRealTime().year + 1900 end
	return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

-- https://wiki.multitheftauto.com/wiki/GetTimestamp
-- With this function you can get the UNIX timestamp
function getTimestamp(year, month, day, hour, minute, second)
	-- initiate variables
	local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
	local timestamp = 0
	local datetime = getRealTime()
	year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
	hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second

	-- calculate timestamp
	for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
	for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
	timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second

	timestamp = timestamp - 3600 --GMT+1 compensation
	if datetime.isdst then timestamp = timestamp - 3600 end

	return timestamp
end

-- Преобразование MySQL-timestamp'а в UNIX формат
-- MySQL: 2016-03-29 18:55:36
function convertTimestampToSeconds(str)
	if type(str) ~= "string" then
		return false
	end
	local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
	local years, months, days, hours, minutes, seconds = str:match(pattern)
	return getTimestamp(years, months, days, hours, minutes, seconds)
end