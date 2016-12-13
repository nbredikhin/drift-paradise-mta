DriftPoints = {}

-- If player is drifting
local isDrifting = false
local isPreventedByCollision = false
-- Drift points total
local driftPoints = 0
-- How many time player is drifting
local driftTimer = 0
local directionDriftTimer = 0
-- How many time player is not drifting
local nonDriftTimer = 0

local driftAngle = 0
local driftDirection = 0

-- Перекладка
local DIRECTION_CHANGE_POINTS = 800
local DIRECTION_CHANGE_MAX_TIME = 1250

local pointsMultiplier = 1
local MAX_MULTIPLIER = 10

-- Points for drift added each frame
local MIN_DRIFT_POINTS = 2
-- Minimum angle, required to start drift
local MIN_DRIFT_ANGLE = 20
-- Minimum speed, required to start drift
local MIN_DRIFT_SPEED = 0.18
-- Скорость, за которую даётся максимальное количество очков
local MAX_DRIFT_SPEED = 0.5
-- Time player have to drift before multiplier raises
local LONG_DRIFT_TIME = 5000
-- Time player can non-drift before multiplier resets
local MAX_NON_DRIFT_TIME = 2000

-- Drift restriction timer
local driftRestrictedTimer = 0
-- Time drift is restricted after collision
local DRIFT_RESTRICT_TIME = 1000

local MIN_COLLISION_FORCE = 350
local MIN_DIRECTION_DRIFT_TIME = 1500

local function isDriftingClose()
	local pos = localPlayer.vehicle.position
	local driftAngleRad = math.rad(driftAngle)

	local forwardDir = localPlayer.vehicle.matrix.forward

	-- dxDrawLine3D(pos.x, pos.y, pos.z, pos.x + 5 * forwardDir.x * math.cos(driftAngleRad), pos.y + 5 * forwardDir.y * math.sin(driftAngleRad), pos.z, 0xffff0000)
	-- dxDrawLine3D(pos.x, pos.y, pos.z, pos.x - 5 * forwardDir.x * math.cos(driftAngleRad), pos.y - 5 * forwardDir.y * math.sin(driftAngleRad), pos.z, 0xff00ff00)

	local resForward = isLineOfSightClear(pos.x, pos.y, pos.z, pos.x + 5 * forwardDir.x * math.cos(driftAngleRad), pos.y + 5 * forwardDir.y * math.sin(driftAngleRad), pos.z, true, false, false)
	local resBackward = isLineOfSightClear(pos.x, pos.y, pos.z, pos.x - 5 * forwardDir.x * math.cos(driftAngleRad), pos.y - 5 * forwardDir.y * math.sin(driftAngleRad), pos.z, true, false, false)

	return (not (resForward and resBackward))
end

local function detectDrift()
	local vehicle = localPlayer.vehicle
	if vehicle.velocity.length < MIN_DRIFT_SPEED then
		return 0, false
	end

	local direction = vehicle.matrix.forward
	local velocity = vehicle.velocity.normalized

	local dot = direction.x * velocity.x + direction.y * velocity.y
	local det = direction.x * velocity.y - direction.y * velocity.x

	local angle = math.deg(math.atan2(det, dot))
	local direction = 1
	if angle < 0 then
		direction = -1
	end
	angle = math.abs(angle)
	-- if true then
	-- 	return 30, true, 1
	-- end
	if angle > MIN_DRIFT_ANGLE and angle < 90 then
		isPreventedByCollision = false

		return angle, true, direction
	else
		return angle, false, direction
	end
end

-- local function detectDrift()
-- 	local velocity = localPlayer.vehicle.velocity
-- 	local direction = localPlayer.vehicle.matrix.forward

-- 	if velocity.length < MIN_DRIFT_SPEED then
-- 		return 0, false
-- 	end
-- 	velocity = velocity:getNormalized()

-- 	local angle = math.abs(math.deg(math.acos(velocity:dot(direction) / (velocity.length * direction.length))))
-- 	if angle > MIN_DRIFT_ANGLE and angle < 90 then
-- 		isPreventedByCollision = false
-- 		return angle, true
-- 	else
-- 		return angle, false
-- 	end
-- end

function finishCurrentDrift(restrictTime)
	-- Reset multipliers
	if driftPoints > 0 then
		--outputChatBox("Finished drift: " .. tostring(driftTimer/1000) .. "s")
		triggerEvent("dpDriftPoints.earnedPoints", resourceRoot, driftPoints, pointsMultiplier, driftTimer)
	end
	if driftPoints > 0 then
		directionDriftTimer = 0
	end
	driftPoints = 0
	driftTimer = 0
	pointsMultiplier = 1
	if type(restrictTime) ~= "number" then
		driftRestrictedTimer = DRIFT_RESTRICT_TIME
	end
	PointsDrawing.hide()
end

local function update(dt)
	if not isElement(localPlayer.vehicle) then
		PointsDrawing.hide()
		return
	end
	if localPlayer.vehicle.controller ~= localPlayer then
		PointsDrawing.hide()
		return
	end

	if not localPlayer.vehicle:isOnGround() then
		return
	end
	if driftRestrictedTimer > 0 then
		driftRestrictedTimer = driftRestrictedTimer - dt
		if driftRestrictedTimer < DRIFT_RESTRICT_TIME / 2 then
			PointsDrawing.hide()
		end
		return
	end

	driftAngle, isDrifting, direction = detectDrift()

	local isChangingDirectionBonusAllowed = false
	local speedMultiplier = math.min(1, localPlayer.vehicle.velocity.length / MAX_DRIFT_SPEED)
	if isDrifting then
		-- Add points and drift time, reset non-drift time
		driftPoints = driftPoints + math.ceil(MIN_DRIFT_POINTS * speedMultiplier * pointsMultiplier * dt * 0.05)
		driftTimer = driftTimer + dt
		directionDriftTimer = directionDriftTimer + dt

		if PointsDrawing.show() then
			driftDirection = direction
		end
		if nonDriftTimer > 250 and nonDriftTimer < DIRECTION_CHANGE_MAX_TIME then
			isChangingDirectionBonusAllowed = true
		end
		nonDriftTimer = 0
		PointsDrawing.setShaking(true)
	else
		PointsDrawing.setShaking(false)
		nonDriftTimer = nonDriftTimer + dt
		if nonDriftTimer > MAX_NON_DRIFT_TIME then
			finishCurrentDrift(0)
			return
		end
		--dxDrawText("Points: " .. driftPoints .. " MULT: x" .. pointsMultiplier, 300, 10, 500, 500, 0xffb57900, 2, "pricedown")
		--PointsDrawing.draw(driftPoints, pointsMultiplier)
		return
	end

	-- if isDriftingClose() then
	-- 	--dxDrawText("NEAR DAMN WALL", 300, 100, 500, 500, 0xffff0000, 2, "pricedown")
	-- end
	-- If drifting lasts long enough, then we add multiplier
	if driftTimer > LONG_DRIFT_TIME then
		driftTimer = 0
		pointsMultiplier = pointsMultiplier + 1

		if pointsMultiplier > MAX_MULTIPLIER then
			pointsMultiplier = MAX_MULTIPLIER
		else
			PointsDrawing.updateMultiplier(pointsMultiplier)
		end
	end
	--outputDebugString(tostring(driftTimer / LONG_DRIFT_TIME))

	if direction ~= driftDirection and isChangingDirectionBonusAllowed then
		driftDirection = direction
		if directionDriftTimer >= MIN_DIRECTION_DRIFT_TIME then
			local scoreValue = math.floor(DIRECTION_CHANGE_POINTS * math.min(1, directionDriftTimer / 3000) / 5 * speedMultiplier) * 5
			giveBonusPoints(scoreValue)
		end
		directionDriftTimer = 0
	end

	PointsDrawing.updatePointsCount(driftPoints, driftAngle * direction)
end

local function onCollision(hitElement, force)
	if source ~= localPlayer.vehicle then
		return
	end
	if force < MIN_COLLISION_FORCE then
		return
	end
	-- If we collided, we reset all drift multipliers
	isDrifting = false
	isPreventedByCollision = true
	PointsDrawing.collision()
	driftTimer = 0
	directionDriftTimer = 0
	driftPoints = 0
	pointsMultiplier = 1
	nonDriftTimer = MAX_NON_DRIFT_TIME
	-- After collision, we should restrict drift for a while
	driftRestrictedTimer = DRIFT_RESTRICT_TIME
end

addEventHandler("onClientPreRender", root, update)
addEventHandler("onClientVehicleCollision", root, onCollision)

function DriftPoints.isDrifting()
	return isDrifting
end

function DriftPoints.isPreventedByCollision()
	return isPreventedByCollision
end

function DriftPoints.isDriftingClose()
	return false--isDriftingClose()
end

function giveBonusPoints(points)
	if type(points) ~= "number" then
		return false
	end
	if not isDrifting and driftPoints == 0 then
		return false
	end
	driftPoints = driftPoints + points
	PointsDrawing.drawBonus(points)
	if not isDrifting then
		PointsDrawing.updatePointsCount(driftPoints)
	end
end
