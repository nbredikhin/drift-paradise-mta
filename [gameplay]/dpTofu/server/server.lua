addEvent("dpTofu.finish", true)
addEventHandler("dpTofu.finish", resourceRoot, function (timePassed, isPerfect)
	local perfectBonus = getPerfectBonus(isPerfect)
	local timeBonus = getTimeBonus(timePassed)
	local moneyReward = getMoneyReward(perfectBonus, timeBonus)
	local xpReward = getXpReward(perfectBonus, timeBonus)

	exports.dpCore:givePlayerMoney(client, moneyReward)
	exports.dpCore:givePlayerXP(client, xpReward)

	triggerClientEvent(client, "dpTofu.finish", client, moneyReward, xpReward, perfectBonus, timeBonus, isPerfect, timePassed)
end)
