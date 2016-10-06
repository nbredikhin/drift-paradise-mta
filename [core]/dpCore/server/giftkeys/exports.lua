-- Создает ключ
-- table options
-- {
--	 string car
-- 	 number money
-- 	 number xp
-- }
function createGiftKey(...)
	return GiftKeys.add(...)
end

function isGiftKeyValid(...)
	return GiftKeys.isKeyValid(...)
end

-- Активирует ключ
-- string key
-- element player
function activateGiftKey(...)
	return GiftKeys.activate(...)
end

-- Удаляет ключ
-- string key
function removeGiftKey(...)
	return GiftKeys.remove(...)
end

-- Список всех ключей
-- table where - поля
function getGiftKeys(where)
	return GiftKeys.getKeys(where)
end