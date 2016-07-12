local vehicle = getElementsByType("vehicle")[1]
local NEON_LINE_SIZE = 5
local neonMaterial = dxCreateTexture("assets/light.png")

local function drawNeonLine(x, y, z, rotation, length, color)
	local hit, hx, hy, hz = processLineOfSight(x, y, z + 1, x, y, z - 1, true, false, false, false, false)
	hz = hz + 0.02
	rotation = math.rad(rotation)
	local ox, oy = math.cos(rotation) * length / 2, math.sin(rotation) * length / 2
	dxDrawMaterialLine3D(
		hx + ox,
		hy + oy,
		hz,
		hx - ox,
		hy - oy,
		hz, 
		neonMaterial, 
		NEON_LINE_SIZE,
		color,
		hx, 
		hy,
		hz + 1
	)
end
addEventHandler("onClientPreRender", root, function ()
	--local position = vehicle.matrix:transformPosition(0, 0, 0)
	--drawNeonLine(position.x, position.y, position.z - 0.1, vehicle.rotation.z, 2.1, tocolor(255, 0, 0, 100))
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	--local shader = exports.dpAssets:createShader("texture_replace.fx")
	--shader:setValue("gTexture", neon)
	--engineApplyShaderToWorldTexture(shader, "shad_car")
	--VehicleShaders.replaceTexture(localPlayer.vehicle, "shad_car", neonMaterial)
end)