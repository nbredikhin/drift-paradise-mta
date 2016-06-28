--
-- c_main.lua
--

local isDynamicSkyStarted = false
function outputDebugString(...) end
---------------------------------
-- shader model version
---------------------------------
function vCardPSVer()
	local smVersion = tostring(dxGetStatus().VideoCardPSVersion)
	outputDebugString("VideoCardPSVersion: "..smVersion)
	return smVersion
end

---------------------------------
-- DepthBuffer access
---------------------------------
function isDepthBufferAccessible()
	local depthStatus = tostring(dxGetStatus().DepthBufferFormat)
	outputDebugString("DepthBufferFormat: "..depthStatus)
	if depthStatus=='unknown' then depthStatus=false end
	return depthStatus
end

----------------------------------------------------------------
-- enableWaterShine
----------------------------------------------------------------
function enableWaterShine()
	if wsEffectEnabled then return end
	-- Create things
	texWaterShader,tecName = dxCreateShader( "fx/tex_water.fx" )
	outputDebugString( "texWaterShader is using technique " .. tostring(tecName) )
	textureVol = dxCreateTexture ( "images/wavemap.png" )
	textureCube = dxCreateTexture ( "images/cube_env256.dds" )
	-- Get list of all elements used
	effectParts = {
						texWaterShader,
						textureVol,
						textureCube
					}

	-- Check list of all elements used
	bAllValid = true
	for _,part in ipairs(effectParts) do
		bAllValid = part and bAllValid
	end
	if not bAllValid then return end
	dxSetShaderValue ( texWaterShader, "sRandomTexture", textureVol );
	dxSetShaderValue ( texWaterShader, "sReflectionTexture", textureCube );
	engineApplyShaderToWorldTexture( texWaterShader, "waterclear256" )
	wsEffectEnabled = true
	if isDynamicSkyStarted then 
		applyDynamicSky() 
	else 
		startShineTimer() 
	end
	
	addEventHandler( "onClientPreRender", root, updateVisibility )
	
	-- Update water color incase it gets changed by persons unknown
	watTimer = setTimer( function()
					if texWaterShader and wsEffectEnabled then
						local r, g, b, a = getWaterColor()
						r, g, b, a = r/255, g/255, b/255, a/255
						dxSetShaderValue ( texWaterShader, "sWaterColor", r, g, b, a )
					end
				end
				,100,0 )	
end

----------------------------------------------------------------
-- disableWaterShine
----------------------------------------------------------------
function disableWaterShine()
	if not wsEffectEnabled then return end
	if texWaterShader then
		engineRemoveShaderFromWorldTexture( texWaterShader, "waterclear256" )
	end
	-- Destroy all shaders
	for _,part in ipairs(effectParts) do
		if part then
			destroyElement( part )
			part = nil
		end
	end
	effectParts = {}
	bAllValid = false

	-- Flag effect as stopped
	wsEffectEnabled = false
	if isDynamicSkyStarted then 
		removeDynamicSky() 
	else 
		killShineTimer() 
	end
	removeEventHandler( "onClientPreRender", root, updateVisibility )
end

-----------------------------------------------------------------------------------
-- dynamicSky exports manage
-----------------------------------------------------------------------------------
addEventHandler("onClientResourceStart", root, function(startedResName)
	local resource_name = tostring(getResourceName(startedResName))
	if resource_name == "shader_dynamic_sky" then
		outputDebugString('WaterShine: Shader_dynamic_sky is starting ...')
		if not isDynamicSkyStarted then 
			isDynamicSkyStarted = exports.shader_dynamic_sky:isDynamicSkyEnabled()
			outputDebugString('WaterShine: Applying dynamicSky vectors')
			applyDynamicSky()
		end
	end
end
)

addEventHandler("onClientResourceStop", root, function(startedResName)
	local resource_name = tostring(getResourceName(startedResName))
	if resource_name == "shader_dynamic_sky" then
		outputDebugString('WaterShine: Shader_dynamic_sky is stopping ...')
		if isDynamicSkyStarted then
			isDynamicSkyStarted = false
			outputDebugString('WaterShine: Removing dynamicSky vectors')
			removeDynamicSky()
		end
	end
end
)

addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), function()
	local this_resource =  getResourceFromName ("shader_dynamic_sky")
	if this_resource then
		if getResourceState (this_resource)=="running" then
			outputDebugString('WaterShine: Shader_dynamic_sky is running ...')
			if not isDynamicSkyStarted then 
				isDynamicSkyStarted = exports.shader_dynamic_sky:isDynamicSkyEnabled()
				outputDebugString('WaterShine: Applying dynamicSky vectors')
				applyDynamicSky()
			end
		end
	end
end
)

local getLastTick = 0
removeWeather = {8,9,16,19,30,31,32,118}
function renderSun()
	if getTickCount() - 80 < getLastTick then return end
	local thisWeather = getWeather()
	local weatherImpact = 1
	for index, nr in ipairs(removeWeather) do
		if nr == thisWeather then weatherImpact = 0 end
	end
	if texWaterShader and wsEffectEnabled then
		local vecX, vecY, vecZ = exports.shader_dynamic_sky:getDynamicSunVector()
		local prevImpact = 1 - math.clamp(0, math.unlerp(0.4, vecZ, 0.15), 1)
		if vecZ < 0 then
			local angImpact = math.clamp(0, math.unlerp(-0.05, vecZ, -0.1), 1)
			dxSetShaderValue( texWaterShader, "sLightDir", vecX, vecY, vecZ)
			local cr, cg, cb, dr, dg, db = getSunColor()
			cr, cg, cb, dr, dg, db = cr/255, cg/255, cb/255, dr/255, dg/255, db/255
			dxSetShaderValue( texWaterShader, "sSunColorTop", cr, cg, cb)
			dxSetShaderValue( texWaterShader, "sSunColorBott", dr, dg, db)
			dxSetShaderValue( texWaterShader, "sSpecularBrightness", 1 * weatherImpact * angImpact)
		else
			vecX, vecY, vecZ = exports.shader_dynamic_sky:getDynamicMoonVector()
			if vecZ < 0 then
				local angImpact = math.clamp(0, math.unlerp(-0.05, vecZ, -0.1), 1)
				local hr, mn = getTime() 
				if hr > 18 then angImpact = angImpact * ((( hr + mn / 60) - 18) / 6) end
				dxSetShaderValue( texWaterShader, "sLightDir", vecX, vecY, vecZ)
				dxSetShaderValue( texWaterShader, "sSunColorTop", 1, 1, 1)
				dxSetShaderValue( texWaterShader, "sSunColorBott", 1, 1, 1)
				local mPhase = exports.shader_dynamic_sky:getMoonPhaseValue()
				mPhase = math.sin(mPhase * math.pi)
				dxSetShaderValue( texWaterShader, "sSpecularBrightness", mPhase * weatherImpact * angImpact * 0.5 * prevImpact)
			end
		end
	end
	getLastTick = getTickCount()
end

local isDynamicSkyEnabled = false
function applyDynamicSky()
if isDynamicSkyEnabled then return end
	if texWaterShader and wsEffectEnabled then 
		dxSetShaderValue( texWaterShader, "sVisibility", 1)
		dxSetShaderValue( texWaterShader, "sSpecularPower", 4 )
		if isTimer(shineTimer) then killShineTimer() end
		addEventHandler("onClientPreRender", root, renderSun )
		isDynamicSkyEnabled = true
	end
end

function removeDynamicSky()
if not isDynamicSkyEnabled then return end
	if texWaterShader and wsEffectEnabled then 
		dxSetShaderValue( texWaterShader, "sVisibility", 0)
		startShineTimer()
		removeEventHandler("onClientPreRender", root, renderSun )
		isDynamicSkyEnabled = false
	end
end

-----------------------------------------------------------------------------------
-- dynamicSky effect on or off
-----------------------------------------------------------------------------------
function switchDynamicSky( dsOn )
	if dsOn then
		outputDebugString('WaterShine: DynamicSky was switched ON')
		applyDynamicSky()
	else
		outputDebugString('WaterShine: DynamicSky was switched OFF')
		removeDynamicSky()
	end
end

addEvent( "switchDynamicSky", true )
addEventHandler( "switchDynamicSky", root, switchDynamicSky )

-----------------------------------------------------------------------------------
-- Light source visiblility detector
-----------------------------------------------------------------------------------
local lightDirection = {0,0,1}
local dectectorPos = 1
local dectectorScore = 0
local detectorList = {
					{ x = -1, y = -1, status = 0 },
					{ x =  0, y = -1, status = 0 },
					{ x =  1, y = -1, status = 0 },

					{ x = -1, y =  0, status = 0 },
					{ x =  0, y =  0, status = 0 },
					{ x =  1, y =  0, status = 0 },

					{ x = -1, y =  1, status = 0 },
					{ x =  0, y =  1, status = 0 },
					{ x =  1, y =  1, status = 0 },
				}

function detectNext ()
	-- Step through detectorList - one item per call
	dectectorPos = ( dectectorPos + 1 ) % #detectorList
	dectector = detectorList[dectectorPos+1]

	local lightDirX, lightDirY, lightDirZ
	
	if isDynamicSkyEnabled then
		local vecX, vecY, vecZ = exports.shader_dynamic_sky:getDynamicSunVector()
		if vecZ < 0 then
			lightDirX, lightDirY, lightDirZ = vecX, vecY, vecZ
		else
			vecX, vecY, vecZ = exports.shader_dynamic_sky:getDynamicMoonVector()
			if vecZ < 0 then
				lightDirX, lightDirY, lightDirZ = vecX, vecY, vecZ
			else
				lightDirX, lightDirY, lightDirZ = 0, 0, 1
			end
		end
	else
		lightDirX, lightDirY, lightDirZ = unpack(lightDirection)
	end
	
	local x, y, z = getElementPosition(localPlayer)

	x = x + dectector.x
	y = y + dectector.y

	local endX = x - lightDirX * 200
	local endY = y - lightDirY * 200
	local endZ = z - lightDirZ * 200

	if dectector.status == 1 then
		dectectorScore = dectectorScore - 1
	end

	dectector.status = isLineOfSightClear ( x,y,z, endX, endY, endZ, true, false, false ) and 1 or 0

	if dectector.status == 1 then
		dectectorScore = dectectorScore + 1
	end

	if dectectorScore < 0 or dectectorScore > 9 then
		outputDebugString ( "dectectorScore: " .. tostring(dectectorScore) )
	end

	-- Enable this to see the 'line of sight' checks
	if false then
		local color = tocolor(255,255,0)
		if dectector.status == 1 then
			color = tocolor(255,0,255)
		end
		dxDrawLine3D ( x,y,z, endX, endY, endZ, color )
	end
end

-----------------------------------------------------------------------------------
-- updateVisibility
-----------------------------------------------------------------------------------
local fadeTarget = 0
local fadeCurrent = 0
function updateVisibility ( deltaTicks )
	if not wsEffectEnabled then return end

	detectNext ()

	if dectectorScore > 0 then
		fadeTarget = 1
	else
		fadeTarget = 0
	end

	local dif = fadeTarget - fadeCurrent
	local maxChange = deltaTicks / 1000
	dif = math.clamp(-maxChange,dif,maxChange)
	fadeCurrent = fadeCurrent + dif

	-- Update shaders
	if texWaterShader then
		dxSetShaderValue( texWaterShader, "sVisibility", fadeCurrent )
	end
end

----------------------------------------------------------------
-- updateShineDirection
----------------------------------------------------------------
-- Big list describing light direction at a particular game time
shineDirectionList = {
			-- H   M    Direction x, y, z,                  sharpness,	brightness,	nightness
			{  0,  0,	-0.019183,	0.994869,	-0.099336,	4,			0.0,		1 },			-- Moon fade in start
			{  0, 30,	-0.019183,	0.994869,	-0.099336,	4,			0.25,		1 },			-- Moon fade in end
			{  3, 00,	-0.019183,	0.994869,	-0.099336,	4,			0.5,		1 },			-- Moon bright
			{  5, 00,	-0.019183,	0.994869,	-0.099336,	4,			0.5,		1 },			-- Moon fade out start
			{  5, 10,	-0.019183,	0.994869,	-0.099336,	4,			0.0,		0 },			-- Moon fade out end

			{  5, 20,	-0.914400,	0.377530,	-0.146093,	4,			0.0,		0 },			-- Sun fade in start
			{  5, 30,	-0.914400,	0.377530,	-0.146093,	4,			1.0,		0 },			-- Sun fade in end
			{  7,  0,	-0.891344,	0.377265,	-0.251386,	4,			1.0,		0 },			-- Sun
			{ 10,  0,	-0.678627,	0.405156,	-0.612628,	4,			0.5,		0 },			-- Sun
			{ 13,  0,	-0.303948,	0.490790,	-0.816542,	4,			0.5,		0 },			-- Sun
			{ 16,  0,	 0.169642,	0.707262,	-0.686296,	4,			0.5,		0 },			-- Sun
			{ 18,  0,	 0.380167,	0.893543,	-0.238859,	4,			0.5,		0 },			-- Sun
			{ 18, 30,	 0.398043,	0.911378,	-0.238859,	4,			1.0,		0 },			-- Sun
			{ 18, 40,	 0.390288,	0.932817,	-0.138859,	4,			1.5,		0 },			-- Sun fade out start
			{ 18, 50,	 0.390288,	0.932817,	-0.118859,	4,			0.0,		0 },			-- Sun fade out end

			{ 19, 01,	 0.390288,	0.932817,	-0.612628,	4,			0.0,		0 },			-- General fade in start
			{ 19, 30,	 0.390288,	0.932817,	-0.612628,	4,			0.0,		0 },			-- General fade in end
			{ 21, 00,	 0.390288,	0.932817,	-0.612628,	4,			0.0,		0 },			-- General fade out start
			{ 22, 09,	 0.390288,	0.932817,	-0.612628,	4,			0.0,		0 },			-- General fade out end

			{ 23, 59,	-0.394331,	0.663288,	-0.077591,	4,			0.0,		1 },			-- Nothing
			}

function updateShineDirection ()
	if not wsEffectEnabled or isDynamicSkyEnabled then return end
	-- Get game time
	local h, m, s = getTimeHMS ()
	local fhoursNow = h + m / 60 + s / 3600

	-- Find which two lines in the shineDirectionList to blend between
	for idx,v in ipairs( shineDirectionList ) do
		local fhoursTo = v[1] + v[2] / 60
		if fhoursNow <= fhoursTo then

			-- Work out blend from line
			local vFrom = shineDirectionList[ math.max( idx-1, 1 ) ]
			local fhoursFrom = vFrom[1] + vFrom[2] / 60

			-- Calc blend factor
			local f = math.unlerp( fhoursFrom, fhoursNow, fhoursTo )

			-- Calc final direction, sharpness and brightness
			local x = math.lerp( vFrom[3], f, v[3] )
			local y = math.lerp( vFrom[4], f, v[4] )
			local z = math.lerp( vFrom[5], f, v[5] )
			local sharpness  = math.lerp( vFrom[6], f, v[6] )
			local brightness = math.lerp( vFrom[7], f, v[7] )
			local nightness = math.lerp( vFrom[8], f, v[8] )

			-- Modify depending upon the weather
			sharpness, brightness = applyWeatherInfluence ( sharpness, brightness, nightness )

			lightDirection = { x, y, z }

			-- Update shaders
			if texWaterShader then
				local cr, cg, cb, dr, dg, db = getSunColor()
				cr, cg, cb, dr, dg, db = cr/255, cg/255, cb/255, dr/255, dg/255, db/255
				if fhoursNow > 5.2 and fhoursNow < 22.1 then
					dxSetShaderValue( texWaterShader, "sSunColorTop", cr, cg, cb)
					dxSetShaderValue( texWaterShader, "sSunColorBott", dr, dg, db)
				else
					dxSetShaderValue( texWaterShader, "sSunColorTop", 1, 1, 1)
					dxSetShaderValue( texWaterShader, "sSunColorBott", 1, 1, 1)				
				end
				
				dxSetShaderValue( texWaterShader, "sLightDir", x, y, z )
				dxSetShaderValue( texWaterShader, "sSpecularPower", sharpness )
				dxSetShaderValue( texWaterShader, "sSpecularBrightness", brightness )
			end

			break
		end
	end
end

function startShineTimer()
	-- Update direction all the time
	shineTimer = setTimer( updateShineDirection, 100, 0 )
end

function killShineTimer()
	killTimer( shineTimer )
end

----------------------------------------------------------------
-- getWeatherInfluence
----------------------------------------------------------------
weatherInfluenceList = {
			-- id   sun:size   :translucency  :bright      night:bright 
			{  0,       1,			0,			1,			1 },		-- Hot, Sunny, Clear
			{  1,       0.8,		0,			1,			1 },		-- Sunny, Low Clouds
			{  2,       0.8,		0,			1,			1 },		-- Sunny, Clear
			{  3,       0.8,		0,			0.8,		1 },		-- Sunny, Cloudy
			{  4,       1,			0,			0.2,		0 },		-- Dark Clouds
			{  5,      1.5,			0,			0.5,		1 },		-- Sunny, More Low Clouds
			{  6,      1.5,			1,			0.5,		1 },		-- Sunny, Even More Low Clouds
			{  7,       1,			0,			0.01,		0 },		-- Cloudy Skies
			{  8,       1,			0,			0,			0 },		-- Thunderstorm
			{  9,       1,			0,			0,			0 },		-- Foggy
			{  10,      1,			0,			1,			1 },		-- Sunny, Cloudy (2)
			{  11,     1.5,			0,			1,			1 },		-- Hot, Sunny, Clear (2)
			{  12,     1.5,			1,			0.5,		0 },		-- White, Cloudy
			{  13,      1,			0,			0.8,		1 },		-- Sunny, Clear (2)
			{  14,      1,			0,			0.7,		1 },		-- Sunny, Low Clouds (2)
			{  15,      1,			0,			0.1,		0 },		-- Dark Clouds (2)
			{  16,      1,			0,			0,			0 },		-- Thunderstorm (2)
			{  17,     1.5,			1,			0.8,		1 }, 		-- Hot, Cloudy
			{  18,     1.5,			1,			0.8,		1 },		-- Hot, Cloudy (2)
			{  19,      1,			0,			0,			0 },		-- Sandstorm
		}

function applyWeatherInfluence ( sharpness, brightness, nightness )

	-- Get info from table
	local id = getWeather()
	id = math.min ( id, #weatherInfluenceList - 1 )
	local item = weatherInfluenceList[ id + 1 ]
	local sunSize  = item[2]
	local sunTranslucency = item[3]
	local sunBright = item[4]
	local nightBright = item[5]

	-- Hack for clouds bug
	if bHasCloudsBug and not getCloudsEnabled() then
		nightBright = 0
	end
	
	-- Modify depending on nightness
	local useSize		  = math.lerp( sunSize, nightness, 1 )
	local useTranslucency = math.lerp( sunTranslucency, nightness, 0 )
	local useBright		  = math.lerp( sunBright, nightness, nightBright )

	-- Apply
	brightness = brightness * useBright
	sharpness = sharpness / useSize

	-- Return result
	return sharpness, brightness
end

----------------------------------------------------------------
-- getTimeHMS
--		Returns game time including seconds
----------------------------------------------------------------
local timeHMS = {0,0,0}
local minuteStartTickCount
local minuteEndTickCount

function getTimeHMS()
	return unpack(timeHMS)
end

addEventHandler( "onClientRender", root,
	function ()
		if not wsEffectEnabled then return end
		local h, m = getTime ()
		local s = 0
		if m ~= timeHMS[2] then
			minuteStartTickCount = getTickCount ()
			local gameSpeed = math.clamp( 0.01, getGameSpeed(), 10 )
			minuteEndTickCount = minuteStartTickCount + 1000 / gameSpeed
		end
		if minuteStartTickCount then
			local minFraction = math.unlerpclamped( minuteStartTickCount, getTickCount(), minuteEndTickCount )
			s = math.min ( 59, math.floor ( minFraction * 60 ) )
		end
		timeHMS = {h, m, s}
		--dxDrawText( string.format("%02d:%02d:%02d",h,m,s), 200, 200 )
	end
)

----------------------------------------------------------------
-- Math helper functions
----------------------------------------------------------------
function math.lerp(from,alpha,to)
    return from + (to-from) * alpha
end

function math.unlerp(from,pos,to)
	if ( to == from ) then
		return 1
	end
	return ( pos - from ) / ( to - from )
end


function math.clamp(low,value,high)
    return math.max(low,math.min(value,high))
end

function math.unlerpclamped(from,pos,to)
	return math.clamp(0,math.unlerp(from,pos,to),1)
end
