--- Виджет кнопки
-- @module dpUI.DpButton

DpButton = {}

local buttonColors = {
	default = "default",
	default_dark = "gray_darker",
	primary = "primary"
}

--- Создать кнопку
-- @function exports.dpUI:createDpButton
-- @tparam table properties таблица параметров
function DpButton.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Button.create(properties)
	widget.type = exports.dpUtils:defaultValue(properties.type, "default")
	widget.font = Fonts.default
	if properties.fontType and Fonts[properties.fontType] then
		widget.font = Fonts[properties.fontType]
	end	
	function widget:updateTheme()
		self.colors = {
			normal = Colors.color(self.colorName),
			hover = Colors.darken(self.colorName, 15),
			down = Colors.darken(self.colorName, 5)
		}
		if self.colorName == "default" then
			self.textColor = tocolor(50, 50, 50)
		end
	end
	widget.colorName = exports.dpUtils:defaultValue(buttonColors[widget.type], "default")
	widget:updateTheme()

	function widget:setType(newType)
		self.colorName = exports.dpUtils:defaultValue(buttonColors[newType], "default")
		self:updateTheme()
		return newType
	end
	return widget
end