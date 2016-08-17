FinishScreen = Screen:subclass("FinishScreen")
local realScreenSize = Vector2(guiGetScreenSize())
local screenWidth, screenHeight
local panelWidth = 405
local panelHeight = 300

local itemHeight = 60
local buttonsHeight = 60

local iconsSize = 20

function FinishScreen:init(playersList)
	self.super:init()
	self.renderTarget = exports.dpUI:getRenderTarget()
	screenWidth, screenHeight = exports.dpUI:getScreenSize()

	self.logoTexture = exports.dpAssets:createTexture("logo.png")
	local textureWidth, textureHeight = dxGetMaterialSize(self.logoTexture)
	self.logoWidth = 415
	self.logoHeight = textureHeight * 415 / textureWidth

	self.itemFont = exports.dpAssets:createFont("Roboto-Regular.ttf", 14)
	self.rankIcon = dxCreateTexture("assets/rank.png")
	self.dollarIcon = dxCreateTexture("assets/dollar.png")
	self.timeIcon = dxCreateTexture("assets/timer.png")

	self.themeColor = {exports.dpUI:getThemeColor()}

	self.ranksColors = {
		{255, 200, 0},
		{200, 200, 230},
		{200, 70, 30}
	}
	self.playersList = {
		{name = "Wherry", prize = 1500, time = "01:15", isLocal = true},
		{name = "flusha", prize = 1000, time = "01:17"},
		{name = "olofmeister", prize = 500, time = "01:25"},
		{name = "dno", prize = 200, time = "01:60"},
		{name = "LONG_TEXT_LONG_TEXT_LONG_TEXT_LONG_TEXT_LONG_TEXT", prize = 200, time = "01:60"},
	}
	self.columns = {
		{source = "name", size = 0.5, icon = self.rankIcon},
		{source = "prize", size = 0.25, icon = self.dollarIcon, space = 0},
		{source = "time", size = 0.25, icon = self.timeIcon, space = 5},
	}
	panelHeight = itemHeight * 5 + buttonsHeight

	showCursor(true)
end

function FinishScreen:hide()
	self.super:hide()

	if isElement(self.itemFont) then
		destroyElement(self.itemFont)
	end
	if isElement(self.rankIcon) then
		destroyElement(self.rankIcon)
	end
	if isElement(self.dollarIcon) then
		destroyElement(self.dollarIcon)
	end	
	if isElement(self.logoTexture) then
		destroyElement(self.logoTexture)
	end
	if isElement(self.timeIcon) then
		destroyElement(self.timeIcon)
	end

	showCursor(false)
end

function FinishScreen:draw()
	self.super:draw()

	dxDrawRectangle(0, 0, realScreenSize.x, realScreenSize.y, tocolor(0, 0, 0, 240 * self.fadeProgress))
	dxSetRenderTarget(self.renderTarget)
	local x = (screenWidth - panelWidth) / 2
	local y = screenHeight / 2 - (panelHeight / 2 + self.logoHeight / 2 + 8) 
	dxDrawImage(screenWidth / 2 - self.logoWidth / 2, y, self.logoWidth, self.logoHeight, self.logoTexture, 0, 0, 0, tocolor(255, 255, 255, 255 * self.fadeProgress))
	y = y + self.logoHeight + 16
	dxDrawRectangle(x, y, panelWidth, panelHeight, tocolor(29, 29, 29, 255 * self.fadeProgress))
	for i, item in ipairs(self.playersList) do
		local color = tocolor(29, 29, 29, 255 * self.fadeProgress)
		if item.isLocal then
			color = tocolor(42, 40, 41, 255 * self.fadeProgress)
		end
		dxDrawRectangle(x, y, panelWidth, itemHeight, color)

		local cx = x
		for j, column in ipairs(self.columns) do
			local iconColor = tocolor(self.themeColor[1], self.themeColor[2], self.themeColor[3], 255 * self.fadeProgress)
			if j == 1 then
				if i <= 3 then
					iconColor = tocolor(self.ranksColors[i][1], self.ranksColors[i][2], self.ranksColors[i][3])
				else
					iconColor = false
				end
			end
			local text = item[column.source]
			local width = panelWidth * column.size
			if iconColor then
				dxDrawImage(cx + 10, y + itemHeight / 2 - iconsSize / 2, iconsSize, iconsSize, column.icon, 0, 0, 0, iconColor)
			end
			local space = 10
			if column.space then
				space = column.space
			end
			dxDrawText(text, cx + 10 + iconsSize + space, y, cx + width, y + itemHeight, tocolor(255, 255, 255), 1, self.itemFont, "left", "center", true)
			cx = cx + width
		end
		y = y + itemHeight
	end

	y = y + (6 - #self.playersList) * itemHeight - buttonsHeight
	dxDrawRectangle(x, y, panelWidth, buttonsHeight, tocolor(212, 0, 40, 255 * self.fadeProgress))
	dxDrawText("Завершить гонку", x, y, x + panelWidth, y + buttonsHeight, tocolor(255, 255, 255), 1, self.itemFont, "center", "center")
	dxSetRenderTarget()
end