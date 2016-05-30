TeleportTab = {}
local panel
local list

function TeleportTab.create()
	panel = Panel.addTab("teleport")
	local width = UI:getWidth(panel)
	local height = UI:getHeight(panel)

	local teleportsList = UI:createDpList {
		x = 0, y = height / 2 - 45 * 3.5,
		width = width, height = 45 * 7,
		items = {
			{"Akina", "Игроков:", "20"},
			{"Ebisu Circuit", "Игроков:", "30"},
			{"Unnamed Map", "Игроков:", "15"},
			{"Unnamed Map 2", "Игроков:", "16"},
			{"Unnamed Map 3", "Игроков:", "52"},
			{"Unnamed Map 4", "Игроков:", "12"},
			{"Unnamed Map 5", "Игроков:", "2"},
		},
		columns = {
			{size = 0.6, offset = 0.07, align = "left"},
			{size = 0.24, alpha = 0.2, align = "right"},
			{size = 0.15, offset = 0.03, align = "left"},
		}
	}
	UI:addChild(panel, teleportsList)	

	list = teleportsList
end

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == list then
		local items = exports.dpUI:getItems(list)
		local selectedItem = exports.dpUI:getActiveItem(list)
		outputChatBox("Selected: " .. tostring(items[selectedItem][1]))
	end
end)
