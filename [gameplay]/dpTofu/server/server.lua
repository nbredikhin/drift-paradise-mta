addEvent("dpTofu.finish", true)
addEventHandler("dpTofu.finish", resourceRoot, function (timePassed, isPerfect)
	local perfectBonus
	if isPerfect then
		perfectBonus = exports.dpShared:getEconomicsProperty("tofu_perfect_mul")
		if not perfectBonus then
			perfectBonus = 1
		end
	else
		perfectBonus = 1
	end

	local timeBonus = 1 + math.max(0, (2 - (timePassed / 60)) / 2)

	if isPerfect then
		perfectBonus = exports.dpShared:getEconomicsProperty("tofu_perfect_mul")
		if not perfectBonus then
			perfectBonus = 1
		end
	else
		timeBonus = 1
	end

	local money = exports.dpShared:getEconomicsProperty("tofu_prize")
	local xp = exports.dpShared:getEconomicsProperty("tofu_xp")

	if not money then
		money = 0
	end
	if not xp then
		xp = 0
	end

	money = math.floor(money * perfectBonus + money * (timeBonus - 1))
	xp = math.floor(xp * perfectBonus + xp * (timeBonus - 1))

	exports.dpCore:givePlayerMoney(client, prize)
	exports.dpCore:givePlayerXP(client, xp)

	triggerClientEvent(client, "dpTofu.finish", client, money, xp, perfectBonus, timeBonus, timePassed, isPerfect)
end)
