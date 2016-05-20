-- If player is drifting
local isDrifting = false
-- Drift points total
local driftPoints = 0
-- How many time player is drifting
local driftTimer = 0
-- How many time player is not drifting
local nonDriftTimer = 0
-- Drift angle
local driftAngle = 0

-- Points multiplier
local pointsMultiplier = 1
-- Maximum points multilier
local MAX_MULTIPLIER = 10

-- Points for drift added each frame
local MIN_DRIFT_POINTS = 10
-- Minimum angle, required to start drift
local MIN_DRIFT_ANGLE = 10
-- Minimum speed, required to start drift
local MIN_DRIFT_SPEED = 0.2
-- Time player have to drift before multiplier raises
local LONG_DRIFT_TIME = 1000
-- Time player can non-drift before multiplier resets
local MAX_NON_DRIFT_TIME = 2000

-- Drift restriction timer
local driftRestrictedTimer = 0
-- Time drift is restricted after collision
local DRIFT_RESTRICT_TIME = 1000

-- local function isDriftingClose()
-- 	local pos = localPlayer.position
-- 	dxDrawLine(pos.x, pos.y, pos.z, pos.x + 2, pos.y, pos.z)
-- end

local function detectDrift()
	local velocity = localPlayer.vehicle.velocity
	local direction = localPlayer.vehicle.matrix.forward

	if velocity.length < MIN_DRIFT_SPEED then 
		return 0, false
	end
	velocity = velocity:getNormalized()
	local angle = math.deg(math.acos(velocity:dot(direction) / (velocity.length * direction.length)))
	if math.abs(angle) > MIN_DRIFT_ANGLE and math.abs(angle) < 90 then
		return math.abs(angle), true
	else
		return math.abs(angle), false
	end
end

local function update(dt)
	if not isElement(localPlayer.vehicle) then
		return
	end

	if not localPlayer.vehicle:isOnGround() then
		return
	end
	isDriftingClose()
	if driftRestrictedTimer > 0 then
		driftRestrictedTimer = driftRestrictedTimer - dt
		dxDrawLine("DRIFT IS RESTRICTED, TIME LEFT: " .. math.floor(driftRestrictedTimer) .. "ms", 500, 500, 500, 500)
		return
	end

	driftAngle, isDrifting = detectDrift()

	if isDrifting then
		 -- Add points and drift time, reset non-drift time
		 driftPoints = driftPoints + MIN_DRIFT_POINTS * pointsMultiplier
		 driftTimer = driftTimer + dt
		 nonDriftTimer = 0
	else 
		nonDriftTimer = nonDriftTimer + dt
		if nonDriftTimer > MAX_NON_DRIFT_TIME then
			-- Reset multipliers
			driftTimer = 0
			pointsMultiplier = 1 
			return
		end
		dxDrawText("Points: " .. driftPoints .. " MULT: x" .. pointsMultiplier, 300, 10, 500, 500, 0xffb57900, 2, "pricedown")
		return
	end

	-- If drifting lasts long enough, then we add multiplier
	if driftTimer > LONG_DRIFT_TIME then
		driftTimer = 0
		pointsMultiplier = pointsMultiplier + 1

		if pointsMultiplier > MAX_MULTIPLIER then
			pointsMultiplier = MAX_MULTIPLIER
		end
	end
	dxDrawText("Points: " .. driftPoints .. ". MULT: x" .. pointsMultiplier, 300, 10, 500, 500, 0xffb57900, 2, "pricedown")
end

local function onCollision()
	-- outputChatBox("LOOOOOL")
	-- If we collided, we reset all drift multipliers
	isDrifting = false
	driftTimer = 0
	pointsMultiplier = 1
	nonDriftTimer = MAX_NON_DRIFT_TIME
	-- After collision, we should restrict drift for a while
	driftRestrictedTimer = DRIFT_RESTRICT_TIME
end

addEventHandler("onClientPreRender", root, update)
addEventHandler("onClientVehicleCollision", root, onCollision)