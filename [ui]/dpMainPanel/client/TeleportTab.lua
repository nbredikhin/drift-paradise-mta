TeleportTab = {}
local panel
local list
local offset = 1
local showCount = 6

local teleports = {
	{ "Akina", 				"akina" },
	{ "Hakone Nanamagari", 	"hakone" },
	{ "YZ Circuit", 		"yz_circuit" },
	{ "Suzuka Circuit", 	"suzuka_circuit" },
	{ "Sekia", 				"sekia" },
	{ "Project Touge", 		"project_touge" },
	{ "Mikawa", 			"mikawa" },
	{ "Mazda Raceway", 		"mazda_raceway" },
	{ "Hero Shinoi", 		"hero_shinoi" },
	{ "Honjo Circuit", 		"honjo_circuit" },
	{ "Gateway International Raceway", "gateway_raceway" },
	{ "GoKart ver.2", 		"gokart2" },
	{ "Ebisu West", 		"ebisu_west" },
	{ "Ebisu Minami", 		"ebisu_minami" },
	{ "Bihoku", 			"bihoku" },
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
	for i = offset, math.min(#teleports, offset + showCount) do
		local name = teleports[i][1]
		local count = 0
		for j, player in ipairs(getElementsByType("player")) do
			if string.lower(tostring(player:getData("activeMap"))) == teleports[i][2] then
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
		for i, teleport in ipairs(teleports) do
			if items[selectedItem][1] == teleport[1] then
				exports.dpTeleports:teleportToMap(teleport[2])
			end
		end
		Panel.setVisible(false)
	end
end)

addEventHandler("onClientKey", root, function (button, down)
	if not down then
		return
	end
	if not Panel.isVisible() or Panel.getCurrentTab() ~= "teleport" then
		return
	end
	if button == "mouse_wheel_up" then
		offset = offset - 1
		if offset < 1 then
			offset = 1
		end
		TeleportTab.refresh()
	elseif button == "mouse_wheel_down" then
		offset = offset + 1
		if offset + showCount > #teleports then
			offset = #teleports - showCount
		end
		TeleportTab.refresh()
	end
end)