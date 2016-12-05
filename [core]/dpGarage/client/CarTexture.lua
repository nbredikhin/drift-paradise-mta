CarTexture = {}
local renderTarget
local vehicle
local bodyColor = {0, 0, 0}
local editorStickers = {}
local DEFAULT_STICKER_SIZE = 300
local selectedSticker = false
local previousSticker = false
local stickerMirroringEnabled = false
local MAX_STICKER_COUNT = 2000

function CarTexture.start()
	vehicle = GarageCar.getVehicle()
	if not isElement(vehicle) then
		return false
	end
	renderTarget = exports.dpVehicles:createVehicleRenderTarget(vehicle)
	if not isElement(renderTarget) then
		return
	end
	editorStickers = {}
	CarTexture.reset()
	CarTexture.redraw()

	addEventHandler("onClientRestore", root, CarTexture.handleRestore)
	stickerMirroringEnabled = false
end

function CarTexture.stop()
	if isElement(renderTarget) then
		destroyElement(renderTarget)
	end

	removeEventHandler("onClientRestore", root, CarTexture.handleRestore)
end

function CarTexture.previewBodyColor(r, g, b)
	bodyColor = {r, g, b}
	CarTexture.redraw()
end

function CarTexture.save()
	if editorStickers then
		vehicle:setData("stickers", editorStickers, false)
	end
end

function CarTexture.reset()
	if not isElement(vehicle) then
		return
	end
	bodyColor = vehicle:getData("BodyColor")
	editorStickers = {}
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
	if not x then return end
	if not y then return end
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
	if not x then return end
	if not y then return end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[3] = sticker[3] + x
	sticker[4] = sticker[4] + y
	CarTexture.redraw()
end

function CarTexture.getSelectedSticker()
	if not selectedSticker then
		return false
	end
	return editorStickers[selectedSticker]
end

function CarTexture.copyPreviousStickerStyle()
	if not selectedSticker then
		return false
	end
	if not previousSticker then
		return false
	end
	local prevSticker = editorStickers[previousSticker]
	local currentSticker = editorStickers[selectedSticker]
	if not prevSticker or not currentSticker then
		return false
	end
	--currentSticker[1] = prevSticker[1]
	--currentSticker[2] = prevSticker[2]
	currentSticker[3] = prevSticker[3]
	currentSticker[4] = prevSticker[4]
	currentSticker[6] = prevSticker[6]
	currentSticker[7] = prevSticker[7]
	return true
end

function CarTexture.setStickerColor(color)
	if not selectedSticker then
		return
	end
	if type(color) ~= "number" then color = tocolor(255, 255, 255) end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[7] = color
	CarTexture.redraw()
end

function CarTexture.getStickerColor()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end
	
	return sticker[7]
end

function CarTexture.rotateSticker(r)
	if not selectedSticker then
		return
	end
	if not r then return end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	sticker[6] = sticker[6] + r
	CarTexture.redraw()
end

function CarTexture.canAddSticker()
	return #editorStickers < MAX_STICKER_COUNT
end

function CarTexture.addSticker(id, x, y, rotation)
	if not CarTexture.canAddSticker() then
		return false
	end
	if type(id) ~= "number" then
		return false
	end
	if not x then x = 0 end
	if not y then y = 0 end
	if not rotation then rotation = 0 end
	local width, height = DEFAULT_STICKER_SIZE, DEFAULT_STICKER_SIZE
	local color = tocolor(255, 255, 255)
	-- Скопировать параметры с предыдущего стикера
	local sticker = {x, y, width, height, id, rotation, color, stickerMirroringEnabled, false}
	table.insert(editorStickers, sticker)
	selectedSticker = #editorStickers
	CarTexture.redraw()
end

function CarTexture.cloneSticker()
	if not selectedSticker then
		return
	end
	if not CarTexture.canAddSticker() then
		return
	end	
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end
	local clonedSticker = {unpack(sticker)}
	table.insert(editorStickers, clonedSticker)
	selectedSticker = #editorStickers

	CarTexture.redraw()
end

function CarTexture.removeSticker()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end
	table.remove(editorStickers, selectedSticker)
	CarTexture.redraw()
	CarTexture.unselectSticker()
end

function CarTexture.redraw()	
	local bodyTexture = false
	exports.dpVehicles:redrawBodyRenderTarget(renderTarget, bodyColor, bodyTexture, editorStickers, selectedSticker)
end

function CarTexture.selectPreviousSticker()
	if not selectedSticker then
		selectedSticker = 1
	end	
	if not selectedSticker or not editorStickers  or #editorStickers == 0 then
		return false
	end
	selectedSticker = selectedSticker - 1
	if selectedSticker < 1 then
		selectedSticker = #editorStickers
	end
	CarTexture.redraw()	
end

function CarTexture.toggleStickerMirroring()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	stickerMirroringEnabled = not stickerMirroringEnabled
	sticker[8] = stickerMirroringEnabled
end

function CarTexture.isMirroringEnabled()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end

	return not not sticker[8]
end

function CarTexture.toggleTextMirroring()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end
	sticker[9] = not sticker[9]
	CarTexture.redraw()
end

function CarTexture.isTextMirroringEnabled()
	if not selectedSticker then
		return
	end
	local sticker = editorStickers[selectedSticker]
	if not sticker then
		return false
	end
	return not not sticker[9]
end

function CarTexture.selectNextSticker()
	if not selectedSticker then
		selectedSticker = 1
	end
	if not selectedSticker or not editorStickers  or #editorStickers == 0 then
		return false
	end
	selectedSticker = selectedSticker + 1
	if selectedSticker > #editorStickers then
		selectedSticker = 1
	end
	CarTexture.redraw()	
end

function CarTexture.unselectSticker()
	if selectedSticker then
		previousSticker = selectedSticker
		selectedSticker = false
	end
	CarTexture.redraw()	
end

function CarTexture.handleRestore(didClearRenderTargets)
	if didClearRenderTargets then
		CarTexture.redraw()
	end
end
