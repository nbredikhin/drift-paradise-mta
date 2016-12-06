Donations = {}

local DONATIONS_TABLE_NAME = "donations"
-- Интервал обновления в минутах
local DONATIONS_UPDATE_INTERVAL = 1

function Donations.setup()
	DatabaseTable.create(DONATIONS_TABLE_NAME, {
		{ name="user_id", type=DatabaseTable.ID_COLUMN_TYPE, options="NOT NULL" },
		-- Вещи, которые даёт ключ
		{ name="money", 	type="bigint", options="UNSIGNED DEFAULT 0" },
		{ name="xp", 		type="bigint", options="UNSIGNED DEFAULT 0" }
	}, "FOREIGN KEY (user_id)\n\tREFERENCES users("..DatabaseTable.ID_COLUMN_NAME..")\n\tON DELETE CASCADE")

	setTimer(Donations.update, DONATIONS_UPDATE_INTERVAL * 1000 * 60, 0)
	Donations.update()
end

local function giveDonationToPlayer(player, donation)
	if not donation then
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

		triggerClientEvent(player, "dpWebAPI.donationSuccess", player, money)
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