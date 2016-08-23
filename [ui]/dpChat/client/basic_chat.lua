local langTitles = {
	en = "chat_tab_english",
	ru = "chat_tab_russian"
}

local function setupLangTabTitle()
	local lang = localPlayer:getData("langChat")
	if not lang then
		lang = "en"
	end
	local title = "English"
	if langTitles[lang] then
		title = exports.dpLang:getString(langTitles[lang])
	end
	Chat.setTabTitle("lang", title)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Chat.createTab("global", "Global", true)
	Chat.createTab("lang", "Lang", true)

	setupLangTabTitle()
end)

addEvent("dpChat.message")
addEventHandler("dpChat.message", root, function (tabName, message)
	if tabName == "global" then
		triggerServerEvent("dpChat.broadcastMessage", root, "global", message)
	elseif tabName == "lang" then
		triggerServerEvent("dpChat.broadcastMessage", root, "lang", message)
	end
end)

addEvent("dpChat.broadcastMessage", true)
addEventHandler("dpChat.broadcastMessage", root, function (tabName, message)
	Chat.message(tabName, message)
end)

addEventHandler("onClientElemenetDataChange", localPlayer, function(dataName)
	if dataName == "langChat" then
		setupLangTabTitle()
	end
end)

addEventHandler("dpLang.languageChanged", root, function ()
	setupLangTabTitle()
end)