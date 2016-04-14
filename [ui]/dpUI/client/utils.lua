local screenWidth, screenHeight = guiGetScreenSize()

function getMousePosition()
	local mx, my = screenWidth / 2, screenHeight / 2
	if isCursorShowing() then
		mx, my = getCursorPosition()
		mx = mx * screenWidth
		my = my * screenHeight
	end
	return mx, my
end

function isPointInRect(x, y, rx, ry, rw, rh)
	return (x >= rx and y >= ry and x <= rx + rw and y <= ry + rh)
end