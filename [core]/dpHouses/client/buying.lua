addEvent("dpCore.buy_house", true)
addEventHandler("dpCore.buy_house", root, function (success)
	if success then
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("houses_message_title"), 
			exports.dpLang:getString("houses_message_buy_success")
		)
	else
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("houses_message_title"), 
			exports.dpLang:getString("houses_message_buy_fail")
		)
	end
end)

addEvent("dpHouses.sell", true)
addEventHandler("dpHouses.sell", root, function (success)
	if success then
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("houses_message_title"), 
			exports.dpLang:getString("houses_message_sell_success")
		)
	else
		exports.dpUI:showMessageBox(
			exports.dpLang:getString("houses_message_title"), 
			exports.dpLang:getString("houses_message_sell_fail")
		)
	end
end)