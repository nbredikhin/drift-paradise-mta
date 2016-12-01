local sound
local lastGear = nil
local lastRPM = nil
local downgrading = false
local downgradingRPM = {0,0}
local downgradingTime = 2000
local downgradingProgress = 0
local start = 0
local worked = 0
local enabled = true

local vehiclesSounds = {
--	[ид модели] = {engine = "звук мотора", blowoff = "звук blowoff", gear = "звук понижения передачи", downTime = как быстро опускается до 0 оборотов мотор в милисекундах, coeff = коэффициент скорости звука мотора },
	 [535] = {engine = "gtr2000.wav",gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.2},
	[475] = {engine = "gtr2000.wav",gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.2},
	  [589] = {engine = "ae86.wav",gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.2},
		  [565] = {engine = "civic.wav",gear = "gear.wav",blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.2},
		   [602] = {engine = "180sx.wav",gear = "gear.wav",blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.2},
		    [401] = {engine = "180sx.wav",gear = "gear.wav",blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.2},
     [576] = {engine = "180sx.wav",gear = "gear.wav",blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.2},
	     [550] = {engine = "rx8.wav",gear = "gear.wav",blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.2},
		     [540] = {engine = "m5.wav",gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.2},
			     [436] = {engine = "m5.wav",gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.2},
		     [529] = {engine = "E92.wav",gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.2},
		     [410] = {engine = "E92.wav",gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.2},
		     [562] = {engine = "gtr34.wav",gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.2},
			 		     [558] = {engine = "gtr35.wav",gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.2},
}

local carSounds = {}

local checkVehicles = {}

local lastVehicle

function startSound(vehicle)
	if not isElement(vehicle) then return true end
	local model = getElementModel ( vehicle )
	if vehiclesSounds[model] then
		if not isElement (carSounds[vehicle]) then
			local x,y,z = getElementPosition ( vehicle )
			local sound = playSound3D ( vehiclesSounds[model].engine, x, y, z, true )
			attachElements ( sound, vehicle )
			local rpm = getVehicleRPM(vehicle)
			setElementData (vehicle, "carsound:lastGear", getVehicleCurrentGear(vehicle), false)
			setElementData (vehicle, "carsound:lastRPM", rpm, false)
			--setElementData (vehicle, "carsound:sound", sound, false)
			carSounds[vehicle] = sound
			if vehiclesSounds[model].volume then
				setSoundVolume ( sound, vehiclesSounds[model].volume )
			end
			--setSoundMaxDistance ( sound, vehiclesSounds[model].maxDistance )
			setSoundSpeed ( sound, rpm/vehiclesSounds[model].coeff )
		end
	end
end

addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
		if not enabled then return true end
        if getElementType( source ) == "vehicle" then
			if lastVehicle and lastVehicle == source then
				startSound(source)
			end
        end
    end
)

addEventHandler( "onClientElementStreamOut", getRootElement( ),
    function ( )
		if not enabled then return true end
        if getElementType( source ) == "vehicle" then
			stopVehicleSound(source)
        end
    end
)

function stopVehicleSound(vehicle)
	local sound = carSounds[vehicle]
	if isElement ( sound ) then
		destroyElement ( sound )
	end
	carSounds[vehicle] = nil
	if isElement ( vehicle ) then
		local downgradingTimers = getElementData ( source, "carsound:downgradingTimers" ) or {}
		if isTimer ( downgradingTimers[1] ) then killTimer ( downgradingTimers[1] ) end
		if isTimer ( downgradingTimers[2] ) then killTimer ( downgradingTimers[2] ) end
	end
end

function checkVehicles(vehicle)
	if not lastVehicle then
		startSound(vehicle)
		lastVehicle = vehicle
		return true
	end
	if lastVehicle and lastVehicle ~= vehicle then
		stopVehicleSound(lastVehicle)
		lastVehicle = vehicle
		startSound(vehicle)
	end
end
addEventHandler("onClientPlayerVehicleEnter",localPlayer,checkVehicles)

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" then
		local sound = carSounds[source]
		if isElement ( sound ) then
			destroyElement ( sound )
		end
		carSounds[source] = nil
		local downgradingTimers = getElementData ( source, "carsound:downgradingTimers" ) or {}
		if isTimer ( downgradingTimers[1] ) then killTimer ( downgradingTimers[1] ) end
		if isTimer ( downgradingTimers[2] ) then killTimer ( downgradingTimers[2] ) end
	end
end)

function disableSounds()
	setWorldSoundEnabled ( 40, false )
	setWorldSoundEnabled ( 12, false )
	addEventHandler("onClientRender", getRootElement(), checkVehiclesRPM )
	-- for i, vehicle in ipairs ( getElementsByType ( "vehicle", root, true ) ) do
        -- startSound(vehicle)
	-- end
end
addEventHandler("onClientResourceStart",getResourceRootElement(),disableSounds)

function turnSoundsOnOff (state)
	if state then
		enabled = true
		setWorldSoundEnabled ( 40, false )
		setWorldSoundEnabled ( 12, false )
		addEventHandler("onClientRender", getRootElement(), checkVehiclesRPM )
		for i, vehicle in ipairs ( getElementsByType ( "vehicle", root, true ) ) do
			startSound(vehicle)
		end
	else
		enabled = false
		setWorldSoundEnabled ( 40, true )
		setWorldSoundEnabled ( 12, true )
		removeEventHandler("onClientRender", getRootElement(), checkVehiclesRPM )
		for i, vehicle in ipairs ( getElementsByType ( "vehicle", root, true ) ) do
			local sound = carSounds[vehicle]
			if isElement ( sound ) then
				destroyElement ( sound )
			end
			carSounds[vehicle] = nil
			local downgradingTimers = getElementData ( vehicle, "carsound:downgradingTimers" ) or {}
			if isTimer ( downgradingTimers[1] ) then killTimer ( downgradingTimers[1] ) end
			if isTimer ( downgradingTimers[2] ) then killTimer ( downgradingTimers[2] ) end
		end
	end
end


function test(text,vehicle)
	if getPedOccupiedVehicle ( localPlayer ) and getPedOccupiedVehicle ( localPlayer ) == vehicle then
		outputChatBox(text)
	end
end

local dot = dxCreateTexture(1,1)
local white = tocolor(255,255,255,255)
function dxDrawRectangle3D(x,y,z,w,h,c,r,...)
        local lx, ly, lz = x+w, y+h, (z+tonumber(r or 0)) or z
	return dxDrawMaterialLine3D(x,y,z, lx, ly, lz, dot, h, c or white, ...)
end

function checkVehiclesRPM()
	local x,y,z = getElementPosition ( localPlayer )
	--for vehicle, sound in pairs ( carSounds ) do
	if lastVehicle then
		if not isElement ( lastVehicle ) then
			stopVehicleSound(lastVehicle)
			return true
		end
		local sound = carSounds[lastVehicle]
		if isElement(sound) then
			local tx, ty, tz = getElementPosition ( lastVehicle )
			if getDistanceBetweenPoints3D (x,y,z,tx,ty,tz) < 40 then
				local rpm = getVehicleRPM(lastVehicle)
				if not getVehicleEngineState(lastVehicle) then
					--if not isSoundPaused ( sound ) then
						setSoundPaused ( sound, true )
					--end
				else
					if rpm == 0 then
						rpm = math.random(300,600)
					end
					if isSoundPaused ( sound ) then
						setSoundPaused ( sound, false )
					end
					local model = getElementModel ( lastVehicle )
					local lastGear = getElementData ( lastVehicle, "carsound:lastGear" ) or 1
					local lastRPM = getElementData ( lastVehicle, "carsound:lastRPM" ) or 0
					local curGear = getVehicleCurrentGear(lastVehicle)
					if lastGear > curGear then
						playGearSound(lastVehicle)
					end
					local downgradingTimers = getElementData ( lastVehicle, "carsound:downgradingTimers" ) or {}
					if lastGear > curGear and not downgrading then
						if isTimer ( downgradingTimers[1] ) then killTimer ( downgradingTimers[1] ) end
						if isTimer ( downgradingTimers[2] ) then killTimer ( downgradingTimers[2] ) end
						downgrading = true
						downgradingProgress = 0
						worked = 0
						start = getTickCount()
						downgradingRPM = {lastRPM,500}
						downgradingTimers[1] = setTimer (function() downgradingProgress = downgradingProgress+(1/(vehiclesSounds[model].downTime/50)) worked = worked+1 end, 50, vehiclesSounds[model].downTime/50)
						--downgradingTimers[2] = setTimer (function() downgrading  = false end, vehiclesSounds[model].downTime, 1)
						setElementData ( lastVehicle, "carsound:downgradingTimers", downgradingTimers, false )
					else
						if vehiclesSounds[model].blowoff and curGear > lastGear then
							playBlowoffSound(lastVehicle)
						end
						if downgrading then
							if ( lastRPM < rpm and ( lastGear <= curGear ) ) or lastGear < curGear then
								if isTimer ( downgradingTimers[1] ) then killTimer ( downgradingTimers[1] ) end
								if isTimer ( downgradingTimers[2] ) then killTimer ( downgradingTimers[2] ) end
								downgrading = false
							end
							local temprpm = interpolateBetween ( downgradingRPM[1], 0, 0, downgradingRPM[2], 0, 0, downgradingProgress, "Linear" )
							setSoundSpeed ( sound, temprpm/vehiclesSounds[model].coeff )
						else
							setSoundSpeed ( sound, rpm/vehiclesSounds[model].coeff )
						end
					end
					setElementData ( lastVehicle, "carsound:lastGear", curGear, false )
					setElementData ( lastVehicle, "carsound:lastRPM", rpm, false )
				end
			end
		end
	end
end

--setTimer(checkVehiclesRPM,500,0)

--addEventHandler("onClientPreRender", getRootElement(), checkVehiclesRPM )
--addEventHandler("onClientResourceStart", getResourceRootElement(),startSound)

function playBlowoffSound(vehicle)
	if isElement ( vehicle ) then
		local x,y,z = getElementPosition ( vehicle )
		local px,py,pz = getElementPosition ( localPlayer )
		if getDistanceBetweenPoints3D ( x,y,z, px,py,pz ) < 10 then
			local model = getElementModel ( vehicle )
			local blowoffSound = playSound3D ( vehiclesSounds[model].blowoff, x, y, z, false )
			attachElements ( blowoffSound, vehicle )
		end
	end
end

function playGearSound(vehicle)
	if isElement ( vehicle ) then
		local x,y,z = getElementPosition ( vehicle )
		local px,py,pz = getElementPosition ( localPlayer )
		if getDistanceBetweenPoints3D ( x,y,z, px,py,pz ) < 10 then
			local model = getElementModel ( vehicle )
			local gearSound = playSound3D ( vehiclesSounds[model].gear, x, y, z, false )
			setSoundVolume(gearSound, 2)
			attachElements ( gearSound, vehicle )
		end
	end
end

function getVehicleRPM(vehicle)
    if isElement(vehicle) then
		local vehicleRPM = getElementData ( vehicle, "rpm" ) or 0
        if (isVehicleOnGround(vehicle)) then
            if (getVehicleEngineState(vehicle) == true) then
                if(getVehicleCurrentGear(vehicle) > 0) then
                    vehicleRPM = math.floor(((getVehicleSpeed(vehicle)/getVehicleCurrentGear(vehicle))*180) + 0.5)

                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9800) then
                        vehicleRPM = 9800
                    end
                else
                    vehicleRPM = math.floor(((getVehicleSpeed(vehicle)/1)*180) + 0.5)

                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9800) then
                        vehicleRPM = 9800
                    end
                end
            else
                vehicleRPM = 0
            end
        else
            if (getVehicleEngineState(vehicle) == true) then
                vehicleRPM = vehicleRPM - 150

                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = 9800
                end
            else
                vehicleRPM = 0
            end
        end
        setElementData ( vehicle, "rpm", vehicleRPM, false )
        return tonumber(vehicleRPM)
    else
        return 0
    end
end

function getVehicleSpeed(vehicle)
    if isElement(vehicle) then
        local vx, vy, vz = getElementVelocity(vehicle)

        if (vx) and (vy)and (vz) then
            return math.sqrt(vx^2 + vy^2 + vz^2) * 180 -- km/h
        else
            return 0
        end
    else
        return 0
    end
end

addEventHandler( "onClientResourceStop", getResourceRootElement( ),
    function ( stoppedRes )
        for i, v in ipairs ( getElementsByType("sound",getResourceRootElement()) ) do
			destroyElement(v)
		end
    end
);
