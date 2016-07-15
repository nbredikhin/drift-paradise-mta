-- Экран гонки
RaceScreen = Screen:subclass("RaceScreen")
local screenSize = Vector2(guiGetScreenSize())
local raceTimeLeft = 0

function RaceScreen:init()
	self.super:init()

	raceTimeLeft = Race.settings.duration
end

local function getTimeString(value)
	local seconds = math.floor(value)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60
	if minutes < 10 then
		minutes = "0" .. tostring(minutes)
	else
		minutes = tostring(minutes)
	end
	if seconds < 10 then
		seconds = "0" .. tostring(seconds)
	else
		seconds = tostring(seconds)
	end
	return tostring(minutes) .. ":" .. tostring(seconds)
end

function RaceScreen:draw()
	self.super:draw()
	dxDrawText("Time left: " .. tostring(getTimeString(raceTimeLeft)), 0, 0, screenSize.x, screenSize.y * 0.1, tocolor(255, 255, 255, 255 * self.fadeProgress), 1, "default", "center", "center")
	dxDrawText("Position: 1/1", 0, screenSize.y * 0.8, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255 * self.fadeProgress), 1, "default", "center", "center")
end

function RaceScreen:update(dt)
	self.super:update(dt)

	raceTimeLeft = raceTimeLeft - dt
end