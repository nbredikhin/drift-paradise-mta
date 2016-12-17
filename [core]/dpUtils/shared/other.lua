function defaultValue(value, default)
	if value == nil then
		return default
	else
		return value
	end
end

-- http://stackoverflow.com/a/2421746
function capitalizeString(str)
    return (str:gsub("^%l", string.upper))
end

function clearChat(...)
	for i = 1, 30 do
		outputChatBox(" ", ...)
	end
end

function isResourceRunning(name)
	local resource = Resource.getFromName(name)
	if not resource then
		return false
	end
	return resource.state == "running"
end

function removeHexFromString(string)
	return string.gsub(string, "#%x%x%x%x%x%x","")
end

function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

function generateString(len)
    if tonumber(len) then
        math.randomseed ( getTickCount () )

        local str = ""
        for i = 1, len do
            str = str .. string.char ( math.random (65, 90 ) )
        end
        return str
    end
    return false
end

function getPlayersByPartOfName(namePart, caseSensitive)
	if not namePart then
		return
	end
	local players = getElementsByType("player")
	if not caseSensitive then
		namePart = string.lower(namePart)
	end
	local matchingPlayers = {}
	for i, player in ipairs(players) do
		local playerName = getPlayerName(player)
		if not caseSensitive then
			playerName = string.lower(playerName)
		end
		if string.find(playerName, namePart) then
			table.insert(matchingPlayers, player)
		end
	end
	return matchingPlayers
end

local _getElementData = getElementData
function getElementDataDefault(element, dataName, defaultValue)
	if not element then
		return defaultValue
	end
	if not dataName then
		return defaultValue
	end
	local value = _getElementData(element, dataName)
	if not value then
		return defaultValue
	end
	return value
end

-- from sam_lie
-- Compatible with Lua 5.0 and 5.1.
-- Disclaimer : use at own risk especially for hedge fund reports :-)

---============================================================
-- add comma to separate thousands
--
function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

---============================================================
-- rounds a number to the nearest decimal places
--
function round(val, decimal)
	if (decimal) then
		return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
	else
		return math.floor(val+0.5)
	end
end

--===================================================================
-- given a numeric value formats output with comma to separate thousands
-- and rounded to given decimal places
--
--
function format_num(amount, decimal, prefix, neg_prefix)
	local str_amount,  formatted, famount, remain

	decimal = decimal or 2  -- default 2 decimal places
	neg_prefix = neg_prefix or "-" -- default negative sign

	famount = math.abs(round(amount, decimal))
	famount = math.floor(famount)

	remain = round(math.abs(amount) - famount, decimal)

				-- comma to separate the thousands
	formatted = comma_value(famount)

				-- attach the decimal portion
	if (decimal > 0) then
		remain = string.sub(tostring(remain),3)
		formatted = formatted .. "." .. remain ..
								string.rep("0", decimal - string.len(remain))
	end

				-- attach prefix string e.g '$'
	formatted = (prefix or "") .. formatted

				-- if value is negative then format accordingly
	if (amount < 0) then
		if (neg_prefix=="()") then
			formatted = "(" .. formatted .. ")"
		else
			formatted = neg_prefix .. formatted
		end
	end

	return formatted
end
