function getPerfectBonus(isPerfect)
    local perfectBonus
    if isPerfect then
        perfectBonus = exports.dpShared:getEconomicsProperty("tofu_perfect_mul")
        if not perfectBonus then
            perfectBonus = 1
        end
    else
        perfectBonus = 1
    end

    return perfectBonus
end

function getTimeBonus(timePassed)
    return 1 + math.max(0, (2 - (timePassed / 60)) / 2)
end

function getMoneyReward(perfectBonus, timeBonus)
    local money = exports.dpShared:getEconomicsProperty("tofu_prize")
    if not money then
		money = 0
	end
    return math.floor(money * perfectBonus + money * (timeBonus - 1))
end

function getXpReward(perfectBonus, timeBonus)
    local xp = exports.dpShared:getEconomicsProperty("tofu_xp")
    if not xp then
        xp = 0
    end
    return math.floor(xp * perfectBonus + xp * (timeBonus - 1))
end
