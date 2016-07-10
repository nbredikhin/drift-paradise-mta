function defaultValue(value, default)
	if value == nil then
		return default
	else
		return value
	end
end

function extendTable(table1, table2)
	if type(table1) ~= "table" or type(table2) ~= "table" then
		return false
	end
	for k, v in pairs(table2) do
		if table1[k] == nil then
			table1[k] = v
		end
	end
	return table1
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