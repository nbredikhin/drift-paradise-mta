addEventHandler("onClientResourceStart", resourceRoot, function ()
	Render.start()

	local parent = Widget.create()
	local rect1 = Rectangle.create({x = 50, y = 50, width = 500, height = 500, color = tocolor(255, 255, 255, 100)})
	local rect2 = Rectangle.create({x = 265, y = 10, width = 250, height = 250, color = tocolor(255, 0, 0)})
	local rect3 = Rectangle.create({x = -10, y = 15, width = 100, height = 200, color = tocolor(255, 150, 0)})
	Widget.addChild(parent, rect1)
	--Widget.addChild(parent, rect2)
	--Widget.addChild(rect2, rect3)

	local button1 = Button.create({text = "Button", x = 10, y = 10, width = 70, height = 25})
	Widget.addChild(rect1, button1)

	local button2 = Button.create({text = "Button 2", x = 90, y = 10, width = 70, height = 25})
	Widget.addChild(rect1, button2)

	Render.resources["test"] = parent

	showCursor(true)
end)