addEvent("dpCore.buy_house", true)
addEventHandler("dpCore.buy_house", root, function (success)
	if success then
		outputChatBox("Вы успешно купили дом")
	else
		outputChatBox("Не удалось купить дом")
	end
end)