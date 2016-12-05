addEvent("dpTofu.finish", true)
addEventHandler("dpTofu.finish", resourceRoot, function (isPerfect)
	local bonus = 0
	local prize = exports.dpShared:getEconomicsProperty("tofu_prize")
	if not prize then
		prize = 0
	end
	if isPerfect then
		bonus = exports.dpShared:getEconomicsProperty("tofu_perfect_mul") 
		if not bonus then
			bonus = 1
		end
		prize = prize * bonus
	end

	local xp = exports.dpShared:getEconomicsProperty("tofu_xp")
	if not xp then
		xp = 0
	end
	
	exports.dpCore:givePlayerMoney(client, prize)
	exports.dpCore:givePlayerXP(client, xp)
end)