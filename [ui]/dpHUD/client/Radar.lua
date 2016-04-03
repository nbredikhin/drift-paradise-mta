Radar = {}
Radar.visible = true
local screenWidth, screenHeight = guiGetScreenSize()

local width, height = Utils.sceenScale(250), Utils.sceenScale(250)
local screenOffset = Utils.sceenScale(20)

local maskShader
local renderTarget

local fallbackTo2d = true

local function drawRadar(x, y)
	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 200))
	dxDrawText("RADAR", x + width / 2 - 20, y + height / 2 - 20)
end

addEventHandler("onClientRender", root, function ()
	if fallbackTo2d then
		drawRadar(screenOffset, screenHeight - height - screenOffset)
	else
		-- Отрисовка радара в renderTarget
		dxSetRenderTarget(renderTarget, false)
		drawRadar(0, 0)
		dxSetRenderTarget()

		maskShader:setValue("sPicTexture", renderTarget)
		
		dxDrawImage(
			screenOffset,
			screenHeight - height - screenOffset, 
			width, 
			height,
			maskShader, 
			0, 0, 0, 
			tocolor(255, 255, 255, 255), 
			DRAW_POST_GUI
		)
	end
end)

function Radar.start()
	if renderTarget then
		return false
	end
	renderTarget = dxCreateRenderTarget(width, height, true)
	maskShader = exports.dpAssets:createShader("mask3d.fx")
	fallbackTo2d = false
	if not (renderTarget and maskShader) then
		fallbackTo2d = true
		outputDebugString("Radar: Fallback to 2d")
		return
	end
end

function Radar.setRotation(x, y, z)
	if not x or not y then
		return false
	end
	if not z then
		z = 0
	end
	if not maskShader then
		return false
	end
	dxSetShaderTransform(maskShader, x, y, z)
end