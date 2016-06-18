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