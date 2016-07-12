ScreenManager = newclass "ScreenManager"

function ScreenManager:init()
	-- Текущий экран
	self.activeScreen = nil
	-- Меняется ли экран в данный момент
	self.isChangingInProgress = false
	self.changingScreenTo = nil
end

-- Отобразить экран
-- screen - объект класса Screen
function ScreenManager:showScreen(screen)
	if not screen then
		return false
	end
	if not screen:class():inherits(Screen) then
		return false
	end
	if self.activeScreen then
		self.activeScreen:startHiding()
		self.isChangingInProgress = true
		self.changingScreenTo = screen
	else
		self.activeScreen = screen
		self.activeScreen.screenManager = self
		self.activeScreen:show()
	end
	return true
end

-- Скрыть текущий активный экран
function ScreenManager:hideScreen()
	if not self.activeScreen then
		return false
	end
	self.activeScreen:hide()
	self.activeScreen.screenManager = nil
	self.activeScreen = nil
	self.isChangingInProgress = false
	return true
end

-- Вызывается при удалении
function ScreenManager:destroy()
	self:hideScreen()
end

function ScreenManager:draw()
	if self.activeScreen then
		self.activeScreen:draw()
	end
end

function ScreenManager:update(deltaTime)
	if self.activeScreen then
		if self.changingScreenTo then
			if self.activeScreen.fadeProgress <= 0 then
				self:hideScreen()
				self:showScreen(self.changingScreenTo)
				self.changingScreenTo = nil
				self.isChangingInProgress = false
			end
		end
		if self.activeScreen then
			self.activeScreen:update(deltaTime)
		end		
	end
end

function ScreenManager:onKey(...)
	if self.isChangingInProgress then
		return
	end
	if self.activeScreen then
		self.activeScreen:onKey(...)
	end
end