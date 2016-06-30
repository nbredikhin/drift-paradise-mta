TeleportTab = {}
local panel
local list

local teleports = {
	"Primring"
}

function TeleportTab.create()
	panel = Panel.addTab("teleport")
	local width = UI:getWidth(panel)
	local height = UI:getHeight(panel)

	local teleportsList = UI:createDpList {
		x = 0, y = height / 2 - 45 * 3.5,
		width = width, height = 45 * 7,
		items = {},
		columns = {
			{size = 0.6, offset = 0.07, align = "left"},
			{size = 0.24, alpha = 0.2, align = "right"},
			{size = 0.15, offset = 0.03, align = "left"},
		}
	}
	UI:addChild(panel, teleportsList)	

	list = teleportsList
end

function TeleportTab.refresh()
	local items = {}
	for i, name in ipairs(teleports) do
		local count = 0
		for i, player in ipairs(getElementsByType("player")) do
			if string.lower(tostring(player:getData("activeMap"))) == string.lower(name) then
				count = count + 1
			end
		end
		table.insert(items, {name, exports.dpLang:getString("main_panel_teleport_players") .. ":", count})
	end
	UI:setItems(list, items)
end

addEvent("dpUI.click", false)
addEventHandler("dpUI.click", resourceRoot, function (widget)
	if widget == list then
		local items = exports.dpUI:getItems(list)
		local selectedItem = exports.dpUI:getActiveItem(list)
		-- outputChatBox("Selected: " .. tostring(items[selectedItem][1]))
		if items[selectedItem][1] == "Primring" then
			exports.dpTeleports:teleportToMap("primring")
		end
		Panel.setVisible(false)
	end
end)
