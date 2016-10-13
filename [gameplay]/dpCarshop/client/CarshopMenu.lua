CarshopMenu = {}
local renderTarget
local MENU_OFFSET = Vector3(-7.5, -7, -0.7)
local position = Vector3()
local size = Vector2(1.5, 1.9)
local rotation = 280
local resolution = size * 250

local headerHeight = 70
local barOffset = 20
local barHeight = 20
local labelHeight = 50

local barsList = {
	{locale = "carshop_label_speed", value = 0.7, param = "speed"},
	{locale = "carshop_label_acceleration", value = 0.4, param = "acceleration"},
	{locale = "carshop_label_control", value = 0.85, param = "control"}
}

local headerFont
local labelFont
local hasDriftHandling = false

local themeColor = {0, 0, 0}
local themeColorHex = "#FFFFFF"

local function draw()
	dxSetRenderTarget(renderTarget)
	dxDrawRectangle(0, 0, resolution.x, resolution.y, tocolor(42, 40, 41))
	dxDrawRectangle(0, 0, resolution.x, headerHeight, tocolor(32, 30, 31))	

	local priceText = ""
	if Carshop.currentVehicleInfo.price > 0 then
		priceText = "$" .. tostring(Carshop.currentVehicleInfo.price)
	else
		priceText = exports.dpLang:getString("price_free")
	end
	dxDrawText(priceText, 0, 0, resolution.x - 20, headerHeight, tocolor(themeColor[1], themeColor[2], themeColor[3]), 1, labelFont, "right", "center")

	local priceWidth = dxGetTextWidth(priceText, 1, labelFont)

	local headerText = Carshop.currentVehicleInfo.name
	local hearderWidth = dxGetTextWidth(headerText, 1, headerFont)
	local hearderScale = math.min(1, (resolution.x - 60 - priceWidth) / hearderWidth)
	dxDrawText(headerText, 20, 0, resolution.x - 20 - priceWidth, headerHeight, tocolor(255, 255, 255), hearderScale, headerFont, "left", "center", true)

	local buyButtonActive = true
	local buyButtonText = exports.dpLang:getString("carshop_buy_button")
	if Carshop.currentVehicleInfo.level > localPlayer:getData("level") then
		buyButtonActive = false
		--"Требуется уровень " .. 
		buyButtonText = string.format(exports.dpLang:getString("carshop_required_level"), tostring(Carshop.currentVehicleInfo.level))
	elseif Carshop.currentVehicleInfo.price > localPlayer:getData("money") then
		buyButtonActive = false
		buyButtonText = exports.dpLang:getString("carshop_no_money")
	end
	if not buyButtonActive then
		dxDrawRectangle(0, resolution.y - headerHeight, resolution.x, headerHeight, tocolor(32, 30, 31))	
		dxDrawText(buyButtonText, 20, resolution.y - headerHeight, resolution.x, resolution.y, tocolor(255, 255, 255, 150), 1, headerFont, "center", "center")		
	else
		dxDrawRectangle(0, resolution.y - headerHeight, resolution.x, headerHeight, tocolor(themeColor[1], themeColor[2], themeColor[3]))	
		dxDrawText(buyButtonText, 20, resolution.y - headerHeight, resolution.x, resolution.y, tocolor(255, 255, 255), 1, headerFont, "center", "center")	
	end

	local y = headerHeight
	local barWidth = resolution.x - barOffset * 2
	for i, bar in ipairs(barsList) do
		-- Подпись
		dxDrawText(bar.text, 0, y, resolution.x, y + labelHeight, tocolor(255, 255, 255), 1, labelFont, "center", "center")
		y = y + labelHeight
		dxDrawRectangle(barOffset, y, barWidth, barHeight, tocolor(65, 65, 65))
		dxDrawRectangle(barOffset, y, barWidth * bar.value, barHeight, tocolor(themeColor[1], themeColor[2], themeColor[3]))

		bar.value = bar.value + (Carshop.currentVehicleInfo.specs[bar.param] - bar.value) * 0.2
		y = y + barHeight * 2
	end
	local labelText = exports.dpLang:getString("carshop_drift_label")
	local valueText = ""
	if Carshop.hasDriftHandling then
		valueText = exports.dpLang:getString("carshop_drift_label_yes")
	else
		valueText = exports.dpLang:getString("carshop_drift_label_no")
	end
	dxDrawText(labelText .. ": " .. themeColorHex .. valueText, 0, y, resolution.x, y + labelHeight, tocolor(255, 255, 255), 1, labelFont, "center", "center", false, false, false, true)

	dxSetRenderTarget()

	local halfHeight = Vector3(0, 0, size.y / 2)
	local rad = math.rad(rotation)
	local lookOffset = Vector3(math.cos(rad), math.sin(rad), 0)
	dxDrawMaterialLine3D(
		position + halfHeight, 
		position - halfHeight, 
		renderTarget, 
		size.x, 
		tocolor(255, 255, 255, 250),
		position + lookOffset
	)
end

function CarshopMenu.start(basePosition)
	position = MENU_OFFSET + basePosition

	renderTarget = dxCreateRenderTarget(resolution.x, resolution.y, false)
	headerFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 20)
	labelFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 18)

	themeColor = {exports.dpUI:getThemeColor()}
	themeColorHex = tostring(exports.dpUtils:RGBToHex(unpack(themeColor)))

	for i, bar in ipairs(barsList) do
		bar.text = exports.dpLang:getString(bar.locale)
	end

	addEventHandler("onClientRender", root, draw)
end

function CarshopMenu.stop()
	if isElement(renderTarget) then
		destroyElement(renderTarget)
	end
	if isElement(headerFont) then
		destroyElement(headerFont)
	end
	if isElement(labelFont) then
		destroyElement(labelFont)
	end	
	removeEventHandler("onClientRender", root, draw)
end