local ui = {}
local carNamesList = {}
local addDiffToCreated = false

local function onTabOpened()
	ui.carsSelect:clear()
	carNamesList = {}
	for name, model in pairs(exports.dpShared:getVehiclesTable()) do
		local readableName = exports.dpShared:getVehicleReadableName(name)
		ui.carsSelect:addItem(readableName)
		table.insert(carNamesList, name)
	end

	triggerServerEvent("dpAdmin.requireGiftKeysList", resourceRoot)
end

addEvent("dpAdmin.requireGiftKeysList", true)
addEventHandler("dpAdmin.requireGiftKeysList", resourceRoot, function (keysList)
	if type(keysList) ~= "table" then
		return
	end
	local oldKeys = {}
	if addDiffToCreated then
		for i = 0, ui.keysList:getRowCount() do
			table.insert(oldKeys, ui.keysList:getItemText(i, 1))
		end
		ui.createdKeysList.text = "-- Keys list"
	end

	ui.keysList:clear()
	for i, key in ipairs(keysList) do
		local user = key.user_id
		if not user then
			user = "none"
		end
		if addDiffToCreated and key.key then
			local found = false
			for j, oldKey in ipairs(oldKeys) do
				if oldKey == key.key then
					found = true
					break
				end
			end
			if not found then
				ui.createdKeysList.text = ui.createdKeysList.text .. key.key .. "\n"
			end
		end
		ui.keysList:addRow(key.key, user, key.money, key.xp, key.car)
	end	

	addDiffToCreated = false
end)

addEvent("dpAdmin.updatedKeys", true)
addEventHandler("dpAdmin.updatedKeys", resourceRoot, function ()
	onTabOpened()
end)


addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = admin.ui.addTab("keys", "Gift keys")

	ui.keysList = GuiGridList(0.34, 0.07, 0.65, 0.84, true, ui.panel)
	ui.keysList:addColumn("Key", 0.18)
	ui.keysList:addColumn("User ID", 0.2)
	ui.keysList:addColumn("Money", 0.2)
	ui.keysList:addColumn("XP", 0.2)
	ui.keysList:addColumn("Car", 0.15)
	ui.keysList:setSelectionMode(1)

	ui.searchKeyEdit = GuiEdit(0.34, 0.01, 0.65, 0.05, "", true, ui.panel)
	ui.removeButton = GuiButton(0.34, 0.84 + 0.07, 0.65, 0.07, "Remove", true, ui.panel)

	local y = 0.015
	GuiLabel(0.02, y, 0.5, 0.05, "Money", true, ui.panel)
	y = y + 0.05
	ui.moneyEdit = GuiEdit(0.02, y, 0.3, 0.05, "0", true, ui.panel)

	y = y + 0.08
	GuiLabel(0.02, y, 0.5, 0.05, "XP", true, ui.panel)
	y = y + 0.05
	ui.xpEdit = GuiEdit(0.02, y, 0.3, 0.05, "0", true, ui.panel)	

	y = y + 0.08
	GuiLabel(0.02, y, 0.5, 0.05, "Car", true, ui.panel)
	y = y + 0.05
	ui.carsSelect = GuiComboBox(0.02, y, 0.3, 0.35, "None", true, ui.panel)

	y = y + 0.12
	GuiLabel(0.02, y, 0.5, 0.05, "Keys count", true, ui.panel)
	y = y + 0.05
	ui.minusButton = GuiButton(0.02, y, 0.03, 0.05, "-", true, ui.panel)
	ui.countEdit = GuiEdit(0.05, y, 0.09, 0.05, "1", true, ui.panel)
	ui.plusButton = GuiButton(0.14, y, 0.03, 0.05, "+", true, ui.panel)
	y = y + 0.08
	ui.createButton = GuiButton(0.02, y, 0.15, 0.07, "Create", true, ui.panel)

	y = y + 0.08			
	GuiLabel(0.02, y, 0.5, 0.05, "Created keys list:", true, ui.panel)
	y = y + 0.05
	ui.createdKeysList = GuiMemo(0.02, y, 0.3, 0.27, "", true, ui.panel)
	ui.createdKeysList:setReadOnly(true)

	addEventHandler("onClientGUITabSwitched", ui.panel, onTabOpened, false)
	addEventHandler("dpAdmin.panelOpened", resourceRoot, onTabOpened)	

	addEventHandler("onClientGUIClick", ui.minusButton, function ()
		ui.countEdit.text = tostring(math.max(1, (tonumber(ui.countEdit.text) or 0) - 1))
	end, false)
	addEventHandler("onClientGUIClick", ui.plusButton, function ()
		ui.countEdit.text = tostring((tonumber(ui.countEdit.text) or 0) + 1)
	end, false)

	addEventHandler("onClientGUIClick", ui.createButton, function ()
		local money = tonumber(moneyEdit) or 0
		if money == 0 then money = nil end
		local xp = tonumber(xpEdit) or 0
		if xp == 0 then xp = nil end
		local car
		if ui.carsSelect.selected >= 0 then
			car = carNamesList[ui.carsSelect.selected + 1]
		end
		addDiffToCreated = true
		triggerServerEvent("dpAdmin.createGiftKeys", resourceRoot, {
			money = money,
			xp = xp,
			car = car
		}, tonumber(ui.countEdit.text) or 0)
	end, false)	

	addEventHandler("onClientGUIClick", ui.removeButton, function ()
		local selectedItems = guiGridListGetSelectedItems(ui.keysList)
		if not selectedItems then
			return
		end
		local keys = {}
		for i, item in pairs(selectedItems) do
			for k, v in pairs(item) do
				outputDebugString(k .. "=" .. tostring(v))
			end
		end
		if #keys > 0 then			
			triggerServerEvent("dpAdmin.removeGiftKeys", resourceRoot, keys)
		end
	end, false)
end)