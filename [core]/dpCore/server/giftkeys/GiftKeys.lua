GiftKeys = {}

local GIFT_KEYS_TABLE_NAME = "gift_keys"
local GIFT_KEY_LENGTH = 6
local GIFT_KEY_SECRET = "wBbNvabPTK2j4ESk"

local keysCounter = 0

function GiftKeys.setup()
	DatabaseTable.create(GIFT_KEYS_TABLE_NAME, {
		{ name="user_id", 	type=DatabaseTable.ID_COLUMN_TYPE },
		{ name="key", 		type="varchar", size=8, options="UNIQUE NOT NULL"},
		-- Вещи, которые даёт ключ
		{ name="money", 	type="bigint", options="UNSIGNED DEFAULT 0"},
		{ name="xp", 		type="bigint", options="UNSIGNED DEFAULT 0" },
		{ name="car", 		type="MEDIUMTEXT" },
		-- Дополнительные данные в JSON
		{ name="data", 		type="MEDIUMTEXT" },		
	}, "FOREIGN KEY (user_id)\n\tREFERENCES users(" .. DatabaseTable.ID_COLUMN_NAME .. ")\n\tON DELETE CASCADE")
end

local function generateKey()
	keysCounter = keysCounter + 1
	local str = base64Encode(
		tostring(getRealTime().timestamp) .. "_" .. 
		tostring(math.random(1000, 9999)) .. "_" .. 
		tostring(getTickCount()) .. "_" ..
		tostring(keysCounter))

	return string.sub(md5(teaEncode(str, GIFT_KEY_SECRET)), 1, GIFT_KEY_LENGTH)
end

function GiftKeys.add(options)
	if type(options) ~= "table" then
		outputDebugString("ERROR: GiftKeys.add: Options must be table")
		return false
	end

	-- Проверка типов полей
	if type(options.money) ~= "number" then options.money = nil end
	if type(options.xp) ~= "number" then options.xp = nil end
	if type(options.car) ~= "string" then options.car = nil end
	-- Проверка значений полей
	if options.money and options.money < 0 then options.money = nil end
	if options.xp and options.xp < 0 then options.xp = nil end
	-- Если такая машина не существует
	if not exports.dpShared:getVehicleModelFromName(options.car) then options.car = nil end

	-- Генерация нового ключа
	local key = generateKey()
	if not key then 
		return false
	end
	local success = DatabaseTable.insert(GIFT_KEYS_TABLE_NAME, { 
		key = key, 
		money = options.money,
		xp = options.xp,
		car = options.car
	}, function (result)
		if result then
			triggerEvent("dpCore.giftKeyAdded", resourceRoot, key)
		end
	end)
	return not not success
end

function GiftKeys.getKeys(where)
	if type(where) ~= "table" then
		where = {}
	end
	return DatabaseTable.select(GIFT_KEYS_TABLE_NAME, {}, where)
end

function GiftKeys.activate(key, player)
	if type(key) ~= "string" or not isElement(player) then
		outputDebugString("ERROR: Failed to activate gift key '" .. tostring(key) .. "' for player '" .. tostring(player) .. "'")
		return false
	end
end

function GiftKeys.remove(key)
	if type(key) ~= "string" then
		return false
	end
	local success = DatabaseTable.delete(GIFT_KEYS_TABLE_NAME, { key = key }, function (result)
		if result then
			triggerEvent("dpCore.giftKeyRemoved", resourceRoot, key)
		end
	end)
	return success
end