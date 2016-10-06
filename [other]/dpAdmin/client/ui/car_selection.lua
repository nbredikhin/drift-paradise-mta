local screenSize = Vector2(guiGetScreenSize())
local windowSize = Vector2(280, 400)
local currentCallback
local ui = {}

function admin.ui.hideCarSelection()
	ui.window.visible = false
	currentCallback = nil
end

function admin.ui.showCarSelection(callback)
	if ui.window.visible or type(callback) ~= "function" then
		return false
	end
	ui.vehiclesList:clear()
	for name, model in pairs(exports.dpShared:getVehiclesTable()) do
		local readableName = exports.dpShared:getVehicleReadableName(name)
		local priceInfo = exports.dpShared:getVehiclePrices(name)
		local price = 0
		if type(priceInfo) == "table" then
			price = unpack(exports.dpShared:getVehiclePrices(name))
		end
		local rowIndex = ui.vehiclesList:addRow(readableName, "$" .. tostring(price))
		ui.vehiclesList:setItemData(rowIndex, 1, name)	
	end
	ui.window.visible = true
	ui.window:bringToFront()
	currentCallback = callback
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.window = GuiWindow(
		(screenSize.x - windowSize.x) / 2, 
		(screenSize.y - windowSize.y) / 2,
		windowSize.x,
		windowSize.y, 
		"", 
		false)

	ui.window.sizable = false
	ui.window.visible = false

	ui.vehiclesList = GuiGridList(0, 0.06, 1, 0.83, true, ui.window)
	ui.vehiclesList:addColumn("Name", 0.6)
	ui.vehiclesList:addColumn("Price", 0.4)
	ui.vehiclesList:setSelectionMode(0)

	ui.cancelButton = GuiButton(0, 0.9, 0.45, 0.1, "Cancel", true, ui.window)
	ui.selectButton = GuiButton(0.5, 0.9, 0.45, 0.1, "Select", true, ui.window)	

	addEventHandler("onClientGUIClick", ui.cancelButton, admin.ui.hideCarSelection, false)
	addEventHandler("onClientGUIClick", ui.selectButton, function ()
		if type(currentCallback) ~= "function" then
			return
		end

		local selectedItems = ui.vehiclesList:getSelectedItems()
		local vehicleName = false
		if selectedItems and #selectedItems > 0 then		
			vehicleName = ui.vehiclesList:getItemData(selectedItems[1].row, 1)
		end
		currentCallback(vehicleName)
		admin.ui.hideCarSelection()
	end, false)
end)