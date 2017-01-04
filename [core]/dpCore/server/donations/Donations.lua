Donations = {}

local DONATIONS_TABLE_NAME = "donations"
-- Интервал обновления в секундах
local DONATIONS_UPDATE_INTERVAL = 10

function Donations.setup()
	DatabaseTable.create(DONATIONS_TABLE_NAME, {
		{ name="user_id", type=DatabaseTable.ID_COLUMN_TYPE, options="NOT NULL" },
		-- Вещи, которые даёт ключ
		{ name="money",   type="bigint", options="UNSIGNED DEFAULT 0" },
		{ name="xp", 	  type="bigint", options="UNSIGNED DEFAULT 0" },
		{ name="premium", type="int",	 options="UNSIGNED DEFAULT 0" }
	}, "FOREIGN KEY (user_id)\n\tREFERENCES users("..DatabaseTable.ID_COLUMN_NAME..")\n\tON DELETE CASCADE")

	setTimer(Donations.update, DONATIONS_UPDATE_INTERVAL * 1000, 0)
	Donations.update()
end

local function giveDonationToPlayer(player, donation)
	if not isElement(player) or not donation then
		exports.dpLogger:log("donations", "Failed to process donation for " .. tostring(player.name))
		return false
	end
	DatabaseTable.delete(DONATIONS_TABLE_NAME, { _id = donation._id }, function (result)
		local money = donation.money
		if type(money) ~= "number" then
			money = 0
		end
		local xp = donation.xp
		if type(xp) ~= "number" then
			xp = 0
		end
		if xp < 0 then
			xp = 0
		end
		if money < 0 then
			money = 0
		end
		givePlayerMoney(player, money)
		givePlayerXP(player, xp)

		local premiumDuration = donation.premium
		if premiumDuration and type(premiumDuration) == "number" then
			local currentPremium = player:getData("premium_expires")
			if type(currentPremium) ~= "number" then
				currentPremium = 0
			end
			local timestamp = getRealTime().timestamp
			local premiumExpireDate = 0
			if currentPremium < timestamp then
				premiumExpireDate = timestamp + premiumDuration
				outputDebugString("Renew player premium")
			else
				premiumExpireDate = currentPremium + premiumDuration
				outputDebugString("Expired player premium")
			end
			player:setData("premium_expires", premiumExpireDate)
			player:setData("isPremium", true)
		end
		triggerClientEvent(player, "dpCore.donation", player)
		exports.dpLogger:log("donations", string.format("Given donation %s to player %s (%s)", 
			tostring(donation._id),
			tostring(player.name),
			tostring(player:getData("username"))))
	end)
end

function Donations.update()
	DatabaseTable.select(DONATIONS_TABLE_NAME, {}, {}, function (result)
		if not result or #result == 0 then 
			return
		end
		outputDebugString("Pending donations count: " .. tostring(#result))

		for i, player in ipairs(getElementsByType("player")) do
			local playerId = player:getData("_id")
			if playerId then
				for _, donation in ipairs(result) do
					if donation.user_id == playerId then
						giveDonationToPlayer(player, donation)
					end
				end
			end
		end
	end)
end