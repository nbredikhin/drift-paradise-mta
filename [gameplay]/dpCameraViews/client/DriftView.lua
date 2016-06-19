DriftView = {}
local isActive = false

local oldX, oldY, oldZ
local wasOnCar
local drawing = true

local height = 1.4 -- как высоко над машиной будет камера
local backOffset = -6 -- на сколько далеко камера будет распологаться от машины
local lookAtOffset = 3 -- как далеко вперед будет смотреть камера (высота камеры)

local targetRotation = 0
local currentRotation = 0
local rotationMul = 0.05

function getPositionInfrontOfElement(x,y,rotation, meters)
    posX = x - math.sin(math.rad(rotation)) * meters
    posY = y + math.cos(math.rad(rotation)) * meters
    return posX, posY, posZ
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


function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end


function differenceBetweenAngles(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	while difference < -180 do
		difference = difference + 360
	end
	while difference > 180 do
		difference = difference - 360
	end
	return difference
end

local function update(deltaTime)
	if localPlayer:getData("activeUI") == "photoMode" then
		return
	end	
	deltaTime = deltaTime / 1000

	local car = getPedOccupiedVehicle(localPlayer)
	if car then
		wasOnCar = true
		local newX, newY, newZ = getElementPosition ( car )
		if oldX and oldY and oldZ then
			local isEnabled = not isMTAWindowActive()
			local e_pressed = getKeyState("e") and isEnabled
			local q_pressed = getKeyState("q") and isEnabled
			
			local carX, carY, carZ = getElementPosition ( car )							
			targetRotation = findRotation( oldX, oldY, newX, newY )	
			if getVehicleSpeed(car) < 5 then
				local _, _, r = getElementRotation(car)
				targetRotation = r
			end				
			if e_pressed and q_pressed then 
				--targetRotation = -car.rotation.z
				targetRotation = car.rotation.z + 180
				currentRotation = targetRotation
			elseif q_pressed then 
				targetRotation = car.rotation.z + 90 
			elseif e_pressed then 
				targetRotation = car.rotation.z - 90 
			end				

			targetRotation = (targetRotation + 180) % 360 - 180		
			currentRotation = (currentRotation + 180) % 360 - 180		
			currentRotation = currentRotation - differenceBetweenAngles(targetRotation, currentRotation) * rotationMul
			local viewX, viewY = getPositionInfrontOfElement(carX, carY, currentRotation, lookAtOffset)
			local cameraX, cameraY = getPositionInfrontOfElement(carX, carY, currentRotation, backOffset)
			setCameraMatrix ( cameraX, cameraY, carZ+height, viewX, viewY, carZ )
		end
		oldX, oldY, oldZ = newX, newY, newZ
	elseif wasOnCar then
		wasOnCar = false
		setCameraTarget ( localPlayer )
	end	
end

function DriftView.start()
	if isActive then
		return false
	end
	isActive = true
	addEventHandler("onClientPreRender", root, update)
end

function DriftView.stop()
	if not isActive then
		return false
	end
	isActive = false	
	removeEventHandler("onClientPreRender", root, update)
end