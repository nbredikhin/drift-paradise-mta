Render = {}
Render.resources = {}

local function draw()
	-- Сброс цвета
	Drawing.setColor()
	-- Сброс системы координат
	Drawing.origin()

	local mouseX, mouseY = getMousePosition()
	for resource, widget in pairs(Render.resources) do
		Widget.draw(widget, mouseX, mouseY)
	end
end

function Render.start()
	addEventHandler("onClientRender", root, draw)
end