CarTexture = {}
local renderTarget
local vehicle
local bodyColor = {0, 0, 0}
local editorStickers = {}

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

function CarTexture.reset()
	if not isElement(vehicle) then
		return
	end
	bodyColor = vehicle:getData("BodyColor")
	editorStickers = vehicle:getData("stickers")
	CarTexture.redraw()
end

function CarTexture.redraw()	
	local bodyTexture = false
	editorStickers = {}
	exports.dpVehicles:redrawBodyRenderTarget(renderTarget, bodyColor, bodyTexture, editorStickers)
end