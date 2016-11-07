HelpPanel = newclass "HelpPanel"
local screenSize = Vector2(guiGetScreenSize())

function HelpPanel:init(helpLines)
    self.helpLines = {}
    for i, line in ipairs(helpLines) do
        self.helpLines[i] = { keys = {}, text = "" }
        for j, key in ipairs(line.keys) do
            table.insert(self.helpLines[i].keys, exports.dpLang:getString(key))
        end
        self.helpLines[i].text = exports.dpLang:getString(line.locale)
    end

    self.font = Assets.fonts.helpPanelText
    self.themeColor = {exports.dpUI:getThemeColor()}
    self.lineHeight = 25
    self.alpha = 255
    self.targetAlpha = 255
end

function HelpPanel:draw(fadeProgress)
    local alpha = self.alpha * fadeProgress
    local y = screenSize.y - 10 - (self.lineHeight + 3) * #self.helpLines
    local x = 10
    local r, g, b = unpack(self.themeColor)
    for i, line in ipairs(self.helpLines) do
        local cx = x
        for j, key in ipairs(line.keys) do
            local keyWidth = dxGetTextWidth(key, 1, self.font) + 10
            dxDrawRectangle(cx, y, keyWidth, self.lineHeight, tocolor(r, g, b, alpha))
            dxDrawText(key, cx, y, cx + keyWidth, y + self.lineHeight, tocolor(255, 255, 255, alpha), 1, self.font, "center", "center")
            cx = cx + keyWidth + 2
        end
        local textWidth = dxGetTextWidth(line.text, 1, self.font) + 10
        dxDrawRectangle(cx, y, textWidth, self.lineHeight, tocolor(42, 40, 42, alpha))
        dxDrawText(line.text, cx, y, cx + textWidth, y + self.lineHeight, tocolor(255, 255, 255, alpha), 1, self.font, "center", "center")
        y = y + self.lineHeight + 3
    end
end

function HelpPanel:update(deltaTime)
    self.alpha = self.alpha + (self.targetAlpha - self.alpha) * deltaTime * 10
end

function HelpPanel:toggle()
    if self.targetAlpha > 255 / 2 then
        self.targetAlpha = 0
    else
        self.targetAlpha = 255
    end
end