local MAX_LEVEL = 100
local xpValues = {}

local function _getXPFromLevel(level)
	if type(level) ~= "number" then
		return
	end
	level = level - 1
	return math.floor(808.0809 * level * (1 + level))
end

for i = 1, MAX_LEVEL + 1 do
	xpValues[i] = _getXPFromLevel(i)
end

function getMaxLevel()
	return MAX_LEVEL
end

function getXPFromLevel(level)
	if type(level) ~= "number" then
		return
	end
	return xpValues[level]
end

function getLevelFromXP(xp)
	if type(xp) ~= "number" then
		return
	end
	local i = 1
	for i = 1, MAX_LEVEL do
		if xp < xpValues[i] then
			return i - 1
		end
	end
	return MAX_LEVEL
end

function getPlayerGarageSlots(player)
	local isPremium = player:getData("isPremium")
	if isPremium then
		return exports.dpShared:getGameplaySetting("premium_garage_slots")
	end

	local slotsLevels = exports.dpShared:getGameplaySetting("garage_slots_levels")
	if not slotsLevels then
		return false
	end
	local playerLevel = player:getData("level") 
	if not playerLevel then
		return false
	end
	local slotsCount = exports.dpShared:getGameplaySetting("default_garage_slots")
	if not slotsCount then
		slotsCount = 3
	end
	for i, level in ipairs(slotsLevels) do
		if level <= playerLevel then
			slotsCount = slotsCount + 1
		end 
	end
	return slotsCount
end