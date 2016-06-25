addEventHandler("onClientResourceStart", resourceRoot, function ()
	-- Создать панель
	Panel.create()
	-- Создать табы
	AccountTab.create()
	TeleportTab.create()
	SettingsTab.create()
	Panel.showTab("settings")
	Panel.setVisible(true)
end)

function isVisible()
	return Panel.isVisible()
end

bindKey("F1", "down", function ()
	Panel.setVisible(not Panel.isVisible())
end)

bindKey("backspace", "down", function ()
	Panel.setVisible(false)
end)

function setVisible(visible)
	Panel.setVisible(visible)
end