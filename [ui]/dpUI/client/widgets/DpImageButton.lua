DpImageButton = {}

function DpImageButton.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	
	local widget = Image.create(properties)
	local hoverSizeAdd = 5
	function widget:draw()
		if self.texture then
			if self.mouseHover then
				Drawing.image(
					self.x - hoverSizeAdd / 2, 
					self.y - hoverSizeAdd / 2, 
					self.width + hoverSizeAdd, 
					self.height + hoverSizeAdd, 
					self.texture
				)
			else
				Drawing.image(self.x, self.y, self.width, self.height, self.texture)
			end
		end
	end
	return widget
end