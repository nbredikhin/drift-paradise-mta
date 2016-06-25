RenderTarget3D = {}
-- Всё ломает внахуи
local DISABLE_3D = false

function RenderTarget3D.create(width, height)
	local rt = {}

	rt.width = width
	rt.height = height
	rt.maskShader = exports.dpAssets:createShader("texture3d.fx")
	rt.renderTarget = dxCreateRenderTarget(width, height, true)

	rt.fallback = not rt.renderTarget or not rt.maskShader or DISABLE_3D

	return rt
end

function RenderTarget3D.set(rt)
	if not rt then
		return
	end
	if rt.renderTarget and not rt.fallback then
		dxSetRenderTarget(rt.renderTarget, true)
	end
end

function RenderTarget3D.draw(rt, x, y, width, height)
	if rt.fallback then
		return
	end
	dxSetShaderValue(rt.maskShader, "sPicTexture", rt.renderTarget)
	dxDrawImage(x, y, width, height, rt.maskShader, 0, 0, 0, tocolor(255, 255, 255, 245), true)
end

function RenderTarget3D.setTransform(rt, rotationX, rotationY, offset)
	if rt.fallback then
		return
	end
	if not offset then
		offset = 0
	end
	dxSetShaderTransform(rt.maskShader, rotationX, rotationY, 0, 0, 0, offset)
end