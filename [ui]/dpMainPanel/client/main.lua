addEventHandler("onClientResourceStart", resourceRoot, function () 
	-- Создать панель
	Panel.create()
	-- Создать табы
	AccountTab.create()
	TeleportTab.create()
	SettingsTab.create()
	Panel.showTab("account")
	Panel.setVisible(false)
end)

bindKey("F1", "down", function ()
	Panel.setVisible(not Panel.isVisible())
end)