----------------------------------------------
--Resource: dynamicLighting:vehicles        --
--Author: Ren712                            --
--Contact: knoblauch700@o2.pl               --
----------------------------------------------

---------------------------------------------------------------------------------------------------
-- editable variables
---------------------------------------------------------------------------------------------------

local vehLiTable = { leftEN ={}, rightEN ={}, left={},right={}, color ={}, isBlown={}, vehType={}, strOut={} }

local gWorldSelfShadow = false -- enables object self shadowing ( may be bugged for rotated objects on a custom map)
local gLightTheta = math.rad(6) -- Theta is the inner cone angle (6)
local gLightPhi = math.rad(20) -- Phi is the outer cone angle (18)
local gLightFalloff = 1.5 -- light intensity attenuation between the phi and theta areas
local gLightAttenuation = 18 -- 15
local flTimerUpdate = 200 -- the effect update time interval
local lightMaxDistance = 60

local excludeVehicleId = {441,464,501,465,564,571,594,606,607,610,611,584,608,450,591}
local isEnabled = false

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z                               -- Return the transformed point
end

local function onPreRender()
	for index,this in ipairs(getElementsByType("vehicle")) do
		if vehLiTable.leftEN[this] or vehLiTable.rightEN[this] then
			local rx, ry, rz = getElementRotation(this, "ZXY")
			rx = rx - 4
			local x1,y1,z1,x2,y2,z2
			local col = vehLiTable.color[this]
			local vehType = vehLiTable.vehType[this]
			if vehType == "Bike" then
				x1,y1,z1 = getPositionFromElementOffset(this,0,0.8,0.1) -- (left,front,above)			
			elseif vehType == "Train" then
				x1,y1,z1 = getPositionFromElementOffset(this,-0.7,5.0,-0.9) -- (left,front,above)
				x2,y2,z2 = getPositionFromElementOffset(this,0.7,5.0,-0.9) -- (left,front,above)
			else
				x1,y1,z1 = getPositionFromElementOffset(this,-0.7,0.8,-0.1) -- (left,front,above)
				x2,y2,z2 = getPositionFromElementOffset(this,0.7,0.8,-0.1) -- (left,front,above)
			end
			
			if vehLiTable.leftEN[this] then
				exports.dynamic_lighting:setLightDirection(vehLiTable.left[this],rx,ry,rz,true)
				exports.dynamic_lighting:setLightPosition(vehLiTable.left[this],x1,y1,z1)
				exports.dynamic_lighting:setLightColor(vehLiTable.left[this],col[1],col[2],col[3],1) 
			end
			if vehLiTable.rightEN[this] and vehType ~= "Bike" then
				exports.dynamic_lighting:setLightDirection(vehLiTable.right[this],rx,ry,rz,true)
				exports.dynamic_lighting:setLightPosition(vehLiTable.right[this],x2,y2,z2)
				exports.dynamic_lighting:setLightColor(vehLiTable.right[this],col[1],col[2],col[3],1)  
			end
		end
	end
end

function createWorldLight()
	return exports.dynamic_lighting:createSpotLight(0,0,3,0,0,0,0,0,0,0,true,gLightFalloff,gLightTheta,gLightPhi,gLightAttenuation,gWorldSelfShadow)
end

function destroyWorldLight(this)
	return exports.dynamic_lighting:destroyLight(this)
end

function isInNightTime()
    local hour, minutes = getTime()
   return (hour>=22 or hour<=5)
end

function lightEffectStop(thisVeh)
	if vehLiTable.leftEN[thisVeh] then
		destroyWorldLight(vehLiTable.left[thisVeh])
		vehLiTable.leftEN[thisVeh]=false
	end
	if vehLiTable.rightEN[thisVeh] then
		destroyWorldLight(vehLiTable.right[thisVeh])
		vehLiTable.rightEN[thisVeh]=false
	end
end

function lightEffectManage(thisVeh,vehType)
	if vehLiTable.isBlown[thisVeh] then return end
	local posX,posY,posZ = getElementPosition(thisVeh)
	local camX,camY,camZ = getCameraMatrix()
	local camDist = getDistanceBetweenPoints3D ( posX,posY,posZ,camX,camY,camZ )
	local lightSwitched = false
	local ispastDist = lightMaxDistance < camDist
	if ispastDist then
		if vehLiTable.leftEN[thisVeh] then
			destroyWorldLight(vehLiTable.left[thisVeh])
			vehLiTable.leftEN[thisVeh]=false		
		end
		if vehLiTable.rightEN[thisVeh] then
			destroyWorldLight(vehLiTable.right[thisVeh])
			vehLiTable.rightEN[thisVeh]=false			
		end
		return
	end
	if ((getVehicleLightState ( thisVeh, 0 )==1 or getVehicleOverrideLights(thisVeh)==1)) and vehLiTable.leftEN[thisVeh] then 
		destroyWorldLight(vehLiTable.left[thisVeh])
		vehLiTable.leftEN[thisVeh]=false		
	end

	if ((getVehicleLightState ( thisVeh, 1 )==1 or getVehicleOverrideLights(thisVeh)==1)) and vehLiTable.rightEN[thisVeh] then 
		destroyWorldLight(vehLiTable.right[thisVeh])
		vehLiTable.rightEN[thisVeh]=false	
	end	
	
	if getVehicleEngineState(thisVeh) then
		if (getVehicleLightState ( thisVeh, 0 )==0 and getVehicleOverrideLights(thisVeh)==0) then 
			if isInNightTime() then
				if vehLiTable.leftEN[thisVeh]~=true and (getVehicleOccupant( thisVeh ,0 ) or not vehLiTable.strOut[thisVeh]) then
					if not ispastDist then
						vehLiTable.left[thisVeh] = createWorldLight()
						vehLiTable.leftEN[thisVeh]=true
						lightSwitched=true
					end
				end
			else
				if vehLiTable.leftEN[thisVeh]==true then
					destroyWorldLight(vehLiTable.left[thisVeh])
					vehLiTable.leftEN[thisVeh]=false
				end
			end
		end
		
		if (getVehicleLightState ( thisVeh, 1 )==0 and getVehicleOverrideLights(thisVeh)==0 and vehType~="Bike")  then
			if isInNightTime() then 
				if vehLiTable.rightEN[thisVeh]~=true and (getVehicleOccupant( thisVeh ,0 ) or not vehLiTable.strOut[thisVeh]) then
					if not ispastDist then
						vehLiTable.right[thisVeh] = createWorldLight()
						vehLiTable.rightEN[thisVeh]=true
						lightSwitched=true
					end
				end
			else
				if vehLiTable.rightEN[thisVeh]==true then
					destroyWorldLight(vehLiTable.right[thisVeh])
					vehLiTable.rightEN[thisVeh]=false
				end
			end
		end
	end

	if (getVehicleLightState ( thisVeh, 0 )==0 and getVehicleOverrideLights(thisVeh)==2) and vehLiTable.leftEN[thisVeh]~=true then
		if not ispastDist then
			vehLiTable.left[thisVeh] = createWorldLight()
			vehLiTable.leftEN[thisVeh]=true
		end
	end
	
	if (getVehicleLightState ( thisVeh, 1 )==0 and getVehicleOverrideLights(thisVeh)==2) and vehLiTable.rightEN[thisVeh]~=true and vehType~="Bike" then
		if not ispastDist then
			vehLiTable.right[thisVeh] = createWorldLight()
			vehLiTable.rightEN[thisVeh]=true
		end
	end
	if lightSwitched then vehLiTable.strOut[thisVeh]=false end
	if vehLiTable.rightEN[thisVeh] or vehLiTable.leftEN[thisVeh] then
		local r,g,b = getVehicleHeadLightColor(thisVeh)
		vehLiTable.color[thisVeh] = {r/255,g/255,b/255}
	end
end

local function onStreamOut()
	if getElementType( source ) == "vehicle" then
		vehLiTable.strOut[source] = true
	end
end

local function onStreamIn()
	if getElementType( source ) == "vehicle" then
		--vehLiTable.strOut[source] = false
	end
end

local function onVehicleExplode()
	if getElementType(source) == "vehicle"  then
		vehLiTable.isBlown[source] = true
		lightEffectStop(source)
	end
end

local function onDestroy()
	if getElementType(source) == "vehicle"  then
		lightEffectStop(source)
	end
end

local shTeNul

local function stopShader()
	if not isEnabled then
		return
	end
	if isTimer(FLenTimer) then
		killTimer(FLenTimer)
	end
	for index,thisVeh in ipairs(getElementsByType("vehicle")) do
		lightEffectStop(thisVeh)
	end	

	removeEventHandler("onClientElementDestroy", root, onDestroy)
	removeEventHandler("onClientVehicleExplode", root, onVehicleExplode)
	removeEventHandler("onClientElementStreamOut", root, onStreamOut)
	removeEventHandler("onClientElementStreamIn", root, onStreamIn)
	removeEventHandler("onClientPreRender", root, onPreRender)

	if isElement(shTeNul) then
		destroyElement(shTeNul)
	end
	isEnabled = false
end

local function startShader()
	if isEnabled then
		return
	end
	shTeNul = dxCreateShader ( "shaders/shader_null.fx",0,0,false )
	engineApplyShaderToWorldTexture(shTeNul, "headlight*" )
	for index,thisVeh in ipairs(getElementsByType("vehicle")) do
		vehLiTable.isBlown[thisVeh] = isVehicleBlown(thisVeh)
		vehLiTable.strOut[thisVeh] = not isElementStreamedIn(thisVeh)
	end
	FLenTimer = setTimer(	function()
		for index,thisVeh in ipairs(getElementsByType("vehicle")) do
			if isElementStreamedIn(thisVeh) then
				local vehType = getVehicleType(thisVeh)
				local vehID = getVehicleID(thisVeh)
				local isMatch = true
				for index,name in ipairs(excludeVehicleId) do
					if vehID==name then isMatch = false end
				end
				vehLiTable.vehType[thisVeh] = vehType
				if isMatch and ((vehType == "Automobile") or (vehType == "Monster Truck") or 
					(vehType == "Bike") or (vehType == "Train")) then
					if isElementStreamedIn(thisVeh) then
						lightEffectManage(thisVeh,vehType)
					elseif not isElementStreamedIn(thisVeh) then
						lightEffectStop(thisVeh)
					end
				end
			end
		end
	end
	,flTimerUpdate,0 )

	addEventHandler("onClientElementDestroy", root, onDestroy)
	addEventHandler("onClientVehicleExplode", root, onVehicleExplode)
	addEventHandler("onClientElementStreamOut", root, onStreamOut)
	addEventHandler("onClientElementStreamIn", root, onStreamIn)
	addEventHandler("onClientPreRender", root, onPreRender)
	isEnabled = true
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	if exports.dpConfig:getProperty("graphics.improved_car_lights") then
		startShader()
	else
		stopShader()
	end
end)

addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
	if key == "graphics.improved_car_lights" then
		if value then
			startShader()
		else
			stopShader()
		end
	end
end)