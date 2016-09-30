CarNamePanel = TuningMenu:subclass "CarNamePanel"


function CarNamePanel:init(position, rotation, bars)
	self.super:init(position, rotation, Vector2(4, 0.3))
	self.headerHeight = 70
	self.text = "Mawina Nazvanie Dlinnoe Pizdec 1488"

	self.labelHeight = 50

	self.barHeight = 20
	self.barOffset = 20

	self.bars = {
		{text = labelText, value = 0},
	}
	self.activeBar = 1
	self.price = 0
end

function CarNamePanel:getValue()
	return self.bars[self.activeBar].value
end

function CarNamePanel:setValue(value)
	if type(value) ~= "number" then
		return false
	end
	value = math.min(1, math.max(0, value))
	self.bars[self.activeBar].value = value
end

function CarNamePanel:draw(fadeProgress)
	self.super:draw(fadeProgress)

	dxSetRenderTarget(self.renderTarget, true)
	dxDrawText(self.text, 0, 0, self.resolution.x, self.resolution.y, tocolor(255, 255, 255), 1, Assets.fonts.carNameText, "center", "center")
	
	dxSetRenderTarget()
end


function CarNamePanel:update(deltaTime)
	self.super:update(deltaTime)
end
