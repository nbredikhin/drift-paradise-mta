CarTexture = {}
local renderTarget
local vehicle
local bodyColor = {0, 0, 0}
local editorStickers = {}
local DEFAULT_STICKER_SIZE = 300
local selectedSticker = 1

function CarTexture.start()
	vehicle = GarageCar.getVehicle()
	if not isElement(vehicle) then
		return false
	end
	renderTarget = exports.dpVehicles:createVehicleRenderTarget(vehicle)
	if not isElement(renderTarget) then
		return
	end
	CarTexture.reset()
	CarTexture.redraw()
end

function CarTexture.stop()
	if isElement(renderTarget) then
		destroyElement(renderTarget)
	end
end

function CarTexture.previewBodyColor(r, g, b)
	bodyColor = {r, g, b}
	--outputDebugString(table.concat(bodyColor, ","))
	CarTexture.redraw()
end

function CarTexture.save()
	if editorStickers then
		vehicle:setData("stickers", editorStickers)
	end
end

function CarTexture.reset()
	if not isElement(vehicle) then
		return
	end
	bodyColor = vehicle:getData("BodyColor")
	editorStickers = vehicle:getData("stickers")
	if not editorStickers then
		editorStickers = {}
	end
	CarTexture.redraw()
end

function CarTexture.moveSticker(x, y)
	if not selectedSticker then
		return
	end
	if not x then x = 0 end
	if not y then y = 0 end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[1] = sticker[1] + x
	sticker[2] = sticker[2] + y
	CarTexture.redraw()
end

function CarTexture.resizeSticker(x, y)
	if not selectedSticker then
		return
	end
	if not x then x = 0 end
	if not y then y = 0 end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[3] = sticker[3] + x
	sticker[4] = sticker[4] + y
	CarTexture.redraw()
end

function CarTexture.rotateSticker(r)
	if not selectedSticker then
		return
	end
	if not x then x = 0 end
	if not y then y = 0 end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[6] = sticker[6] + r
	CarTexture.redraw()
end

function CarTexture.addSticker(id, x, y, rotation)
	if type(id) ~= "number" then
		return false
	end
	if not x then x = 0 end
	if not y then y = 0 end
	if not rotation then rotation = 0 end
	local sticker = {x, y, DEFAULT_STICKER_SIZE, DEFAULT_STICKER_SIZE, id, rotation, tocolor(255, 255, 255), true}
	table.insert(editorStickers, sticker)
	selectedSticker = #editorStickers
	CarTexture.redraw()
end

function CarTexture.redraw()	
	local bodyTexture = false
	exports.dpVehicles:redrawBodyRenderTarget(renderTarget, bodyColor, bodyTexture, editorStickers)
end