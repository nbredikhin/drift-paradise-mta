addEvent("dpDriftPoints.earnedPoints", true)
addEventHandler("dpDriftPoints.earnedPoints", resourceRoot, function (points)
    local driftMoney = exports.dpShared:getEconomicsProperty("drift_money") or 0
	local driftXP = exports.dpShared:getEconomicsProperty("drift_xp") or 0

	local money = math.floor(points / 100000 * driftMoney)
    local xp = math.floor(points / 100000 * driftXP)

    exports.dpCore:givePlayerMoney(client, money)
	exports.dpCore:givePlayerXP(client, xp)
end)