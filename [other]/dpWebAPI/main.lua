local SHOP_KEY = "322DE1661CCB45C3B0"
local SHOP_ID = 35625
local shopItems = {}

local function getHash(data)
    local json = '{'
        .. '"shop_id":' .. data.shop_id .. ','
        .. '"item_id":' .. data.item_id .. ','
        .. '"payment":{'
            .. '"nickname":"'    .. data.payment.nickname .. '",'
            .. '"cost":'            .. data.payment.cost .. ','
            .. '"withdraw_status":' .. tostring(data.payment.withdraw_status)
        .. '}}'

    return string.lower(sha256(json .. SHOP_KEY))
end

function processPayment(data)
    if type(data) ~= "table" then
        outputDebugString("Invalid JSON")
        return "Invalid JSON"
    end
    if not data.hash then
        outputDebugString("Bad hash")
        return "Bad hash"
    end
    if string.lower(data.hash) ~= getHash(data) then
        outputDebugString("Hash is not valid")
        return "Hash is not valid"
    end

    local payment = data.payment
    if not payment then
        outputDebugString("Bad payment")
        return "Bad payment"
    end

    local username = payment.nickname
    if type(shopItems[data.item_id]) == "number" then
        exports.dpCore:giveUserPremium(username, shopItems[data.item_id])
    end
end

fetchRemote("http://api.trademc.org/shop.getItems?params[shop]=" .. SHOP_ID, function (data, err)
    if err ~= 0 then return end
    data = fromJSON(data)
    if not data or not data.response then 
        return 
    end
    local response = data.response
    for i, item in ipairs(response.items) do
        local daysCount = tonumber(split(item.name, " ")[1])
        if daysCount then
            shopItems[item.id] = daysCount * 24 * 60 * 60
        end
    end
end)