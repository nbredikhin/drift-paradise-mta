-- Настройки шейдера
Variables = {}
Variables.renderDistance= 50 -- shader will be applied to textures nearer than this
Variables.brightnessFactorPaint= 0.081
Variables.brightnessFactorWShield= 0.49
Variables.bumpSize =0.02 -- for car paint
Variables.bumpSizeWnd =0 -- for windshields
Variables.normal = 1.5 -- the higher , the less normalised 0-2
Variables.brightnessAdd =0.5 -- before bright pass
Variables.brightnessMul = 1.5 -- multiply after brightpass
Variables.brightpassCutoff = 0.16 -- 0-1
Variables.brightpassPower = 2 -- 1-5
Variables.reflectionFlip = 1 -- 0 or 1
Variables.reflectionFlipAngle =0.25 -- -1,1
Variables.dirtTexture = 1 -- 0 or 1

Variables.sProjectedXsize=0.5
Variables.sProjectedXvecMul=1
Variables.sProjectedXoffset=-0.021
Variables.sProjectedYsize=0.5
Variables.sProjectedYvecMul=1
Variables.sProjectedYoffset=-0.22

local isEnabled = false
local CONFIG_PROPERTY_NAME = "graphics.reflections_cars"

local screenWidth, screenHeight = guiGetScreenSize()

local screenSource
local grunShader, geneShader, shatShader
local textureVol

local function updateScreen()
	if screenSource then
		dxUpdateScreenSource(screenSource)
	end
end

local function createShader()
	if getVersion().sortable < "1.3.0" then
		return false
	end	
	grunShader = dxCreateShader("car_refgrun.fx", 1, Variables.renderDistance, false)
	geneShader = dxCreateShader("car_refgene.fx", 1, Variables.renderDistance, true)
	shatShader = dxCreateShader("car_refgene.fx", 1, Variables.renderDistance, true)

	if not grunShader or not geneShader or not shatShader then
		return false
	end

	screenSource = dxCreateScreenSource(screenWidth, screenHeight)
	addEventHandler("onClientHUDRender", root, updateScreen)

	--Set variables
	dxSetShaderValue(grunShader, "sCutoff", Variables.brightpassCutoff)
	dxSetShaderValue(grunShader, "sPower", Variables.brightpassPower)			
	dxSetShaderValue(grunShader, "sAdd", Variables.brightnessAdd)
	dxSetShaderValue(grunShader, "sMul", Variables.brightnessMul)
	dxSetShaderValue(grunShader, "sRefFl", Variables.reflectionFlip)
	dxSetShaderValue(grunShader, "sRefFlan", Variables.reflectionFlipAngle)
	dxSetShaderValue(grunShader, "sNorFac", Variables.normal)
	dxSetShaderValue(grunShader, "brightnessFactor",Variables.brightnessFactorPaint)  

	dxSetShaderValue(geneShader, "sCutoff",Variables.brightpassCutoff)
	dxSetShaderValue(geneShader, "sPower", Variables.brightpassPower)	
	dxSetShaderValue(geneShader, "sAdd", Variables.brightnessAdd)
	dxSetShaderValue(geneShader, "sMul", Variables.brightnessMul)
	dxSetShaderValue(geneShader, "sRefFl", Variables.reflectionFlip)
	dxSetShaderValue(geneShader, "sRefFlan", Variables.reflectionFlipAngle)
	dxSetShaderValue(geneShader, "sNorFac", Variables.normal)
	dxSetShaderValue(geneShader, "brightnessFactor",Variables.brightnessFactorWShield) 

	dxSetShaderValue(shatShader, "sCutoff",Variables.brightpassCutoff)
	dxSetShaderValue(shatShader, "sPower", Variables.brightpassPower)	
	dxSetShaderValue(shatShader, "sAdd", Variables.brightnessAdd)
	dxSetShaderValue(shatShader, "sMul", Variables.brightnessMul)
	dxSetShaderValue(shatShader, "sRefFl", Variables.reflectionFlip)
	dxSetShaderValue(shatShader, "sRefFlan", Variables.reflectionFlipAngle)
	dxSetShaderValue(shatShader, "sNorFac", Variables.normal)
	dxSetShaderValue(shatShader, "brightnessFactor",Variables.brightnessFactorWShield) 		

	dxSetShaderValue(grunShader, "dirtTex",Variables.dirtTexture)
	dxSetShaderValue(grunShader, "bumpSize",Variables.bumpSize)
	dxSetShaderValue(geneShader, "bumpSize",Variables.bumpSizeWnd)

	dxSetShaderValue(grunShader, "sProjectedXsize",Variables.sProjectedXsize)
	dxSetShaderValue(grunShader, "sProjectedXvecMul",Variables.sProjectedXvecMul)
	dxSetShaderValue(grunShader, "sProjectedXoffset",Variables.sProjectedXoffset)
	dxSetShaderValue(grunShader, "sProjectedYsize",Variables.sProjectedYsize)
	dxSetShaderValue(grunShader, "sProjectedYvecMul",Variables.sProjectedYvecMul)
	dxSetShaderValue(grunShader, "sProjectedYoffset",Variables.sProjectedYoffset)

	dxSetShaderValue(geneShader, "sProjectedXsize",Variables.sProjectedXsize)
	dxSetShaderValue(geneShader, "sProjectedXvecMul",Variables.sProjectedXvecMul)
	dxSetShaderValue(geneShader, "sProjectedXoffset",Variables.sProjectedXoffset)
	dxSetShaderValue(geneShader, "sProjectedYsize",Variables.sProjectedYsize)
	dxSetShaderValue(geneShader, "sProjectedYvecMul",Variables.sProjectedYvecMul)
	dxSetShaderValue(geneShader, "sProjectedYoffset",Variables.sProjectedYoffset)

	dxSetShaderValue(shatShader, "sProjectedXsize",Variables.sProjectedXsize)
	dxSetShaderValue(shatShader, "sProjectedXvecMul",Variables.sProjectedXvecMul)
	dxSetShaderValue(shatShader, "sProjectedXoffset",Variables.sProjectedXoffset)
	dxSetShaderValue(shatShader, "sProjectedYsize",Variables.sProjectedYsize)
	dxSetShaderValue(shatShader, "sProjectedYvecMul",Variables.sProjectedYvecMul)
	dxSetShaderValue(shatShader, "sProjectedYoffset",Variables.sProjectedYoffset)

	-- Set textures
	textureVol = dxCreateTexture("images/smallnoise3d.dds")

	dxSetShaderValue(grunShader, "sRandomTexture", textureVol)
	dxSetShaderValue(grunShader, "sReflectionTexture", screenSource)

	dxSetShaderValue(geneShader, "gShatt", 0)
	dxSetShaderValue(geneShader, "sRandomTexture", textureVol)
	dxSetShaderValue(geneShader, "sReflectionTexture", screenSource)

	dxSetShaderValue(shatShader, "gShatt", 1)
	dxSetShaderValue(shatShader, "sRandomTexture", textureVol)
	dxSetShaderValue(shatShader, "sReflectionTexture", screenSource)			

	-- Apply to world texture
	engineApplyShaderToWorldTexture(grunShader, "vehiclegrunge256")
	engineApplyShaderToWorldTexture(grunShader, "?emap*")
	engineApplyShaderToWorldTexture(geneShader, "vehiclegeneric256")
	engineApplyShaderToWorldTexture(shatShader, "vehicleshatter128")

	engineApplyShaderToWorldTexture(geneShader, "hotdog92glass128")

	-- Для машин Drift Paradise
	engineApplyShaderToWorldTexture(grunShader, "body")
	engineApplyShaderToWorldTexture(shatShader, "body")
	engineApplyShaderToWorldTexture(geneShader, "body")

	local texturegrun = {
		"predator92body128", "monsterb92body256a", "monstera92body256a", "andromeda92wing","fcr90092body128",
		"hotknifebody128b", "hotknifebody128a", "rcbaron92texpage64", "rcgoblin92texpage128", "rcraider92texpage128", 
		"rctiger92body128","rhino92texpage256", "petrotr92interior128","artict1logos","rumpo92adverts256","dash92interior128",
		"coach92interior128","combinetexpage128","hotdog92body256", "raindance92body128", "cargobob92body256", 
		"andromeda92body", "at400_92_256", "nevada92body256","polmavbody128a" , "sparrow92body128" , "hunterbody8bit256a" , 
		"seasparrow92floats64", "dodo92body8bit256" , "cropdustbody256", "beagle256", "hydrabody256", "rustler92body256", 
		"shamalbody256", "skimmer92body128", "stunt256", "maverick92body128", "leviathnbody8bit256"
	}
			
	for _, addList in ipairs(texturegrun) do
		engineApplyShaderToWorldTexture(grunShader, addList)
	end	
end

local function destroyShader()
	if isElement(grunShader) then destroyElement(grunShader) end
	if isElement(geneShader) then destroyElement(geneShader) end
	if isElement(shatShader) then destroyElement(shatShader) end
	if isElement(screenSource) then destroyElement(screenSource) end
	if isElement(textureVol) then destroyElement(textureVol) end

	removeEventHandler("onClientHUDRender", root, updateScreen)
end


function setEnabled(enabled)
	enabled = not not enabled
	if enabled == isEnabled then
		return
	end
	isEnabled = enabled

	if enabled then
		createShader()
	else
		destroyShader()
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	setEnabled(exports.dpConfig:getProperty(CONFIG_PROPERTY_NAME))
end)

addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if key == CONFIG_PROPERTY_NAME then
		setEnabled(value)
	end
end)