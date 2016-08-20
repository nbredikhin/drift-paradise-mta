FinishScreen = Screen:subclass("FinishScreen")
local realScreenSize = Vector2(guiGetScreenSize())
local screenWidth, screenHeight
local panelWidth = 405
local panelHeight = 300

local itemHeight = 60
local buttonsHeight = 60

local iconsSize = 20

function FinishScreen:init()
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
	self.mouseOver = false

	self.ranksColors = {
		{255, 200, 0},
		{200, 200, 230},
		{200, 70, 30}
	}
	self.playersList = {}
	self:setPlayersList(Race.getFinishedPlayers())
	-- self.playersList = {
	-- 	{name = "Wherry", prize = 1500, time = "01:15", isLocal = true},
	-- 	{name = "flusha", prize = 1000, time = "01:17"},
	-- 	{name = "olofmeister", prize = 500, time = "01:25"},
	-- 	{name = "dno", prize = 200, time = "01:60"},
	-- 	{name = "LONG_TEXT_LONG", prize = 200, time = "01:60"},
	-- }
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
	local buttonColor = tocolor(212, 0, 40, 255 * self.fadeProgress)
	local mx, my = getCursorPosition()
	if  mx and 
		mx * realScreenSize.x > x and 
		mx * realScreenSize.x < x + panelWidth and 
		my * realScreenSize.y > y and 
		my * realScreenSize.y < y + buttonsHeight 
	then
		buttonColor = tocolor(222, 20, 60, 255 * self.fadeProgress)
		self.mouseOver = true
	else
		self.mouseOver = false
	end
	dxDrawRectangle(x, y, panelWidth, buttonsHeight, buttonColor)
	dxDrawText("Завершить гонку", x, y, x + panelWidth, y + buttonsHeight, tocolor(255, 255, 255), 1, self.itemFont, "center", "center")
	dxSetRenderTarget()
end

function FinishScreen:onKey(key, state)
	self.super:onKey()
	if not state then
		return 
	end

	if key == "mouse1" and self.mouseOver then
		Race.stop()
	end
end

local function getTimeString(value)
	local seconds = math.floor(value)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60
	if minutes < 10 then
		minutes = "0" .. tostring(minutes)
	else
		minutes = tostring(minutes)
	end
	if seconds < 10 then
		seconds = "0" .. tostring(seconds)
	else
		seconds = tostring(seconds)
	end
	return tostring(minutes) .. ":" .. tostring(seconds)
end

function FinishScreen:setPlayersList(players)
	if type(players) ~= "table" then
		return false
	end

	self.playersList = {}
	for i, playerInfo in ipairs(players) do
		table.insert(self.playersList, { 
			name = playerInfo.player.name,
			prize = playerInfo.money,
			time = getTimeString(math.floor(playerInfo.time / 1000))
		})
	end
end