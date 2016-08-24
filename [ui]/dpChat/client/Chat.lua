Chat = {}

local MAX_CHAT_LINES = 8
local MAX_VISIBLE_TABS = 6
local MAX_TAB_WIDTH = 72

local isVisible = false
local chatTabs = {}
local activeTabName
local highlightedTabName
local screenSize = Vector2(guiGetScreenSize())

function Chat.setVisible(visible)
	visible = not not visible
	if visible == isVisible then
		return false
	end

	if visible then

	else
		Input.close()
	end

	isVisible = visible
end

function Chat.isVisible()
	return not not isVisible
end

function Chat.removeTab(name)
	if type(name) ~= "string" then
		return false
	end
	local tab, index = Chat.getTabFromName(name)
	if not tab then
		return false
	end
	if tab.unremovable then
		return false
	end
	table.remove(chatTabs, index)
	if name == activeTabName then
		if #chatTabs > 0 then
			activeTabName = chatTabs[1].name
		else
			activeTabName = nil
		end
	end
end

function Chat.getTabFromName(name)
	if type(name) ~= "string" then
		return false
	end
	for i, tab in ipairs(chatTabs) do
		if tab.name == name then
			return tab, i
		end
	end
end

function Chat.setTabTitle(name, title)
	if type(name) ~= "string" or type(title) ~= "string" then
		return false
	end
	local tab = Chat.getTabFromName(name)
	if not tab then
		return false
	end
	tab.title = title
	return true
end

function Chat.createTab(name, title, unremovable)
	if Chat.getTabFromName(name) then
		outputDebugString("Chat: tab '" .. tostring(name) .. "' already exists")
		return false
	end
	local tab = {
		name = name, 
		title = title,
		unremovable = not not unremovable,
		messages = {

		}
	}
	if not activeTabName then
		activeTabName = name
	end
	table.insert(chatTabs, tab)
end

function Chat.message(tabName, text, r, g, b, colorCoded)
	if type(tabName) ~= "string" or type("message") ~= "string" then
		return false
	end
	local tab = Chat.getTabFromName(tabName)
	if not tab then
		return false
	end

	local color
	if r and g and b then
		color = tocolor(r, g, b)
	end
	if colorCoded == nil then
		colorCoded = true
	else
		colorCoded = not not colorCoded
	end
	local message = {
		text = text,
		textWithoutColors = text:gsub("#%x%x%x%x%x%x", ""),
		color = color,
		colorCoded = colorCoded
	}

	table.insert(tab.messages, message)
end

function Chat.setActiveTab(name)
	if type(name) ~= "string" then
		return
	end
	if name == activeTabName then
		return false
	end
	if Chat.getTabFromName(name) then
		activeTabName = name
		return true
	end
end

local function drawMessages()
	local tab = Chat.getTabFromName(activeTabName)
	if not tab then
		return
	end
	local messages = tab.messages
	local messageCount = #messages

	local firstIndex = 1
	if messageCount > MAX_CHAT_LINES then
		firstIndex = messageCount - MAX_CHAT_LINES + 1
	end

	local j = MAX_CHAT_LINES - 1
	for i = messageCount, firstIndex, -1 do
		local message = messages[i]
		text = message.text
		dxDrawText(message.textWithoutColors, 33, 33 + j * 20, 0, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, false, false, false, true)
		dxDrawText(text, 32, 32 + j * 20, 0, 0, message.color, 1.0, "default-bold", "left", "top", false, false, false, message.colorCoded, true)
		j = j - 1
	end
end

function drawTabs()
	local mouseVisible = isCursorShowing()
	local mx, my = getCursorPosition()
	if mx then
		mx, my = mx * screenSize.x, my * screenSize.y
	else
		mx = 0
		my = 0
	end

	local scale = 1.0
	local font = "default-bold"
	local x = 32
	local y = 16
	local height = 12
	local limitTabs = not (my > y / 2 and my < y + height)
	highlightedTabName = nil
	for i, tab in ipairs(chatTabs) do
		local width = math.min(dxGetTextWidth(tab.title, scale, font), MAX_TAB_WIDTH)
		local alpha = 200
		if mx > x and mx < x + width and my > y and my < y + height then
			limitTabs = false
			alpha = 255

			if getKeyState("mouse1") then
				Chat.setActiveTab(tab.name)
			end

			highlightedTabName = tab.name
		end

		local color = tocolor(255, 255, 255, alpha)
		if tab.name == activeTabName then
			color = tocolor(212, 0, 40, alpha)
		end		
		-- Текст
		dxDrawText(tab.title, x, y, x + width, y + height, color, scale, font, "left", "center", true)
		
		x = x + 5 + width
		if i == MAX_VISIBLE_TABS and limitTabs then
			break
		end
	end
end

function Chat.getActiveTab()
	return activeTabName
end

function Chat.clearTab(name)
	local tab = Chat.getTabFromName(name)
	if not tab then
		return
	end
	tab.messages = {}
	return false
end

function drawInput()
	if not Input.isActive() then
		return
	end
	local text = exports.dpLang:getString("chat_input_message") .. ": " .. Input.getText()
	local right = 32 + dxGetTextWidth(text:sub(1, 96), 1, "default-bold")
	dxDrawText(text, 33, 33 + MAX_CHAT_LINES * 20, right + 1, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, true, false, false, true)
	dxDrawText(text, 32, 32 + MAX_CHAT_LINES * 20, right, 0, 0xFFFFFFFF, 1.0, "default-bold", "left", "top", false, true, false, false, true)
end

addEventHandler("onClientRender", root, function ()
	if not isVisible then
		return
	end
	drawTabs()
	drawMessages()
	drawInput()
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	showChat(false)
	Chat.setVisible(true)
end)

bindKey("mouse2", "down", function ()
	Chat.removeTab(highlightedTabName)
end)

setTimer(showChat, 1000, 0, false)