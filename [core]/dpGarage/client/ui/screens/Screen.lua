Screen = newclass "Screen"

function Screen:init()
	-- Прогресс появления 
	-- Используется для анимации появления/исчезания экрана
	self.fadeProgress = 0
	self.fadeSpeed = 2
	self.fadeState = ""

	self.isActive = false
	self.screenManager = nil
end

function Screen:show()
	if self.isActive then
		return false
	end
	self.isActive = true

	self.fadeProgress = 0
	self.fadeState = "show"
	return true
end

-- Запуск анимации исчезания экрана
function Screen:startHiding()
	self.fadeProgress = 1
	self.fadeState = "hide"
end

-- Скрыть экран
function Screen:hide()
	if not self.isActive then
		return false
	end
	self.isActive = false 
end

function Screen:draw()

end

function Screen:onKey()

end

function Screen:update(deltaTime)
	if self.isActive then
		-- Плавное появление/исчезание экрана
		if self.fadeState == "show" then
			self.fadeProgress = math.min(1, self.fadeProgress + self.fadeSpeed * deltaTime)
		elseif self.fadeState == "hide" then
			self.fadeProgress = math.max(0, self.fadeProgress - self.fadeSpeed * deltaTime)
			if self.fadeProgress <= 0 then
				self:hide()
			end
		end
	end
end