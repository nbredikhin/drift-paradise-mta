Screen = Drawable:subclass "Screen"

function Screen:init()
	self.super:init()
	self.children = {}
end

function Screen:addChild(drawable)
	table.insert(self.children, drawable)
end

function Screen:draw()
	for i, drawable in ipairs(self.children) do
		drawable:draw()
	end
end

function Screen:update(deltaTime)
	for i, drawable in ipairs(self.children) do
		drawable:update(deltaTime)
	end
end

function Screen:callback(func, ...)
	if type(self.func) == "function" then
		self.func(self, ...)
	end
	for i, drawable in ipairs(self.children) do
		if type(drawable.func) == "function" then
			drawable.func(drawable, ...)
		end
	end
end

function Screen:onShow()

end

function Screen:onHide()

end