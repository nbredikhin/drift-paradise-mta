function wrapAngle(value)
	if not value then
		return 0
	end
	value = math.mod(value, 360)
	if value < 0 then
		value = value + 360
	end
	return value
end

function wrapAngleRadians(value)
	if not value then
		return 0
	end
	local pi2 = math.pi * 2
	value = math.mod(value, pi2)
	if value < 0 then
		value = value + pi2
	end
	return value
end

function differenceBetweenAngles(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	if difference > 180 then
		difference = difference - 360
	elseif difference < -180 then
		difference = difference + 360
	end
	return difference
end

function differenceBetweenAnglesRadians(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	if difference > math.pi then
		difference = difference - math.pi * 2
	elseif difference < -math.pi then
		difference = difference + math.pi * 2
	end
	return difference
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

	famount = math.abs(round(amount,decimal))
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
	if (amount<0) then
		if (neg_prefix=="()") then
			formatted = "("..formatted ..")"
		else
			formatted = neg_prefix .. formatted 
		end
	end

	return formatted
end