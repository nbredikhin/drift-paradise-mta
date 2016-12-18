local TOFU_POINT_POSITIONS = {
    {
        marker = Vector3(1821.247, -1842.192, 12.6),
        ped = {position = Vector3(1828.649, -1842.192, 13.578), rotation = 90},
        music = Vector3(1835.613, -1842.073, 13.078)
    },
    {
        marker = Vector3(473.9, -1296.518, 14.5),
        ped = {position = Vector3(468.605, -1290.124, 15.435),  rotation = 210},
        music = Vector3(471.078, -1280.93, 15.435)
    }
}

local PED_MODEL = 10
local CHECKPOINTS_COUNT = 32
local MIN_COLLISION_FORCE = 350

local tofuPoints = {}

local isRunning = false
local isThereCollision = false
local startTime = 0

local screenSize = Vector2(guiGetScreenSize())

function screenScale(val)
	if screenSize.x < 1280 then
		return val * screenSize.x / 1280
	end
	return val
end


local font = exports.dpAssets:createFont("Roboto-Regular.ttf", screenScale(20))

addEvent("dpMarkers.use", false)

local function draw()
	-- colors
	local bgColorR, bgColorG, bgColorB = exports.dpUI:getThemeColor(nil, "gray_darker")
	local bg2ColorR, bg2ColorG, bg2ColorB = exports.dpUI:getThemeColor(nil, "gray_dark")
	local bgColor = tocolor(bgColorR, bgColorG, bgColorB, 255)
	local bg2Color = tocolor(bg2ColorR, bg2ColorG, bg2ColorB, 255)

	local themeColorR, themeColorG, themeColorB = exports.dpUI:getThemeColor()
	local themeColor = tocolor(themeColorR, themeColorG, themeColorB, 255)
	local themeColorHEX = exports.dpUtils:RGBToHex(themeColorR, themeColorG, themeColorB)

    -- name
    local textWidth
    local nameBgOffsetX = screenScale(20)
    local nameBgWidth, nameBgHeight = screenScale(256), screenScale(48)
    local nameBgOffsetY = screenScale(366)
    dxDrawRectangle(nameBgOffsetX, screenSize.y - nameBgHeight - nameBgOffsetY, nameBgWidth, nameBgHeight, themeColor)

    local textOffsetX = screenScale(10)
	local textOffsetY = screenScale(8)
	local fontHeight = font:getHeight()

    local nameText = exports.dpLang:getString("tofu_blip_text")
	textWidth = font:getTextWidth(nameText, 1, true)
	local nameTextX = nameBgOffsetX + textOffsetX
	textY = screenSize.y - (nameBgOffsetY)
	dxDrawText(nameText, nameTextX, textY - nameBgHeight, nameBgOffsetX + nameBgWidth - textOffsetX, textY, 0xFFFFFFFF, 1, font, "left", "center", true, false, false, false, true)

	-- bg
	local bgOffsetX = screenScale(20)
	local bgWidth, bgHeight = screenScale(256), screenScale(48)
	local bgOffsetY = screenScale(318)
	dxDrawRectangle(bgOffsetX, screenSize.y - bgHeight - bgOffsetY, bgWidth, bgHeight, bgColor)

	local bg2OffsetX = screenScale(20)
	local bg2OffsetY = screenScale(270)
	local bg2Width, bg2Height = screenScale(256), screenScale(48)
	dxDrawRectangle(bg2OffsetX, screenSize.y - bg2Height - bg2OffsetY, bg2Width, bg2Height, bg2Color)

	-- text
	local elapsedTime = getElapsedTime()

	-- checkpoints
	local checkpointsText = ("%d%s/#FFFFFF%d"):format(RaceCheckpoints.getCurrentCheckpoint(), themeColorHEX, RaceCheckpoints.getCheckpointsCount())
	textWidth = font:getTextWidth(checkpointsText, 1, true)
	local checkpointsTextX = bgOffsetX + textOffsetX
	textY = screenSize.y - (bgOffsetY)
	dxDrawText(checkpointsText, checkpointsTextX, textY - bgHeight, checkpointsTextX + textWidth, textY, 0xFFFFFFFF, 1, font, "left", "center", false, false, false, true, true)

	-- time
	local timeText = ("#FFFFFF%02d%s:#FFFFFF%02d"):format(elapsedTime / 60, themeColorHEX, elapsedTime % 60)
	textWidth = font:getTextWidth(timeText, 1, true)
	local timeTextX = (bgOffsetX + bgWidth) - textWidth - textOffsetX
	dxDrawText(timeText, timeTextX, textY - bgHeight, timeTextX + textWidth, textY, 0xFFFFFFFF, 1, font, "right", "center", false, false, false, true, true)

	-- money
	local perfectBonus = getPerfectBonus(false)
	local timeBonus = getTimeBonus(elapsedTime)

	local moneyText = ("+%s%s"):format(themeColorHEX, exports.dpUtils:format_num(getMoneyReward(perfectBonus, timeBonus), 0, "$"))
	textWidth = font:getTextWidth(moneyText, 1, true)
	local moneyTextX = bg2OffsetX + textOffsetX
	textY = screenSize.y - (bg2OffsetY)
	dxDrawText(moneyText, moneyTextX, textY - bg2Height, checkpointsTextX + textWidth, textY, 0xFFFFFFFF, 1, font, "left", "center", false, false, false, true, true)

	-- xp
	local xpText = ("+%s%s XP"):format(themeColorHEX, exports.dpUtils:format_num(getXpReward(perfectBonus, timeBonus), 0))
	textWidth = font:getTextWidth(xpText, 1, true)
	local xpTextX = (bg2OffsetX + bg2Width) - textWidth - textOffsetX
	dxDrawText(xpText, xpTextX, textY - bg2Height, xpTextX + textWidth, textY, 0xFFFFFFFF, 1, font, "right", "center", false, false, false, true, true)
end

local function takeTofu()
    if isRunning then
        exports.dpUI:showMessageBox(
            exports.dpLang:getString("tofu_message_box_title"),
            exports.dpLang:getString("tofu_message_box_text"))
        return
    end

    if not localPlayer.vehicle then
        return
    end

    if localPlayer.vehicle.controller ~= localPlayer then
        return
    end

    tofuVehicle = localPlayer.vehicle

    local checkpointsList = exports.dpPathGenerator:generateCheckpointsForPlayer(localPlayer, CHECKPOINTS_COUNT)
    RaceCheckpoints.start(checkpointsList)
    isRunning = true
    isThereCollision = false
    startTime = getRealTime().timestamp

    for i, tofuPoint in ipairs(tofuPoints) do
        tofuPoint.ped:setAnimation("DANCING", "dance_loop")
    end

    addEventHandler("onClientRender", root, draw)
    addEventHandler("onClientElementDestroy", tofuVehicle, cancelTofu)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local txd = EngineTXD("skin/1.txd")
    txd:import(PED_MODEL)
    local dff = EngineDFF("skin/1.dff")
    dff:replace(PED_MODEL)

    for i, point in ipairs(TOFU_POINT_POSITIONS) do
        local markerPosition = point.marker
        local pedPosition = point.ped
        local musicPosition = point.music

        -- marker
        local marker = exports.dpMarkers:createMarker("tofu", markerPosition, 0)
        addEventHandler("dpMarkers.use", marker, takeTofu)

        local blip = Blip(0, 0, 0, 27)
        blip:attach(marker)
        blip:setData("text", "tofu_blip_text")

        -- ped
        local ped = Ped(PED_MODEL, pedPosition.position, pedPosition.rotation)
        ped.frozen = true
        addEventHandler("onClientPedDamage", ped, cancelEvent)

        -- ped colshape
        local colshape = ColShape.Sphere(pedPosition.position, 5.0)

        -- music
        local sound
        if exports.dpConfig:getProperty("game.background_music") then
            sound = Sound3D("music/music.mp3", musicPosition, true)
            sound.minDistance = 20
            sound.maxDistance = 50
        end

        tofuPoints[i] = {
            marker = marker,
            blip = blip,
            ped = ped,
            colshape = colshape,
            sound = sound
        }
    end
end)

function cancelTofu()
    if not isRunning then
        return false
    end

    removeEventHandler("onClientRender", root, draw)
    removeEventHandler("onClientElementDestroy", tofuVehicle, cancelTofu)

    isRunning = false
    startTime = 0
    RaceCheckpoints.stop()
    for i, tofuPoint in ipairs(tofuPoints) do
        tofuPoint.ped:setAnimation()
    end

    tofuVehicle = nil
end

function getElapsedTime()
    return getRealTime().timestamp - startTime
end

function finishTofu()
    if not isRunning then
        return false
    end

    triggerServerEvent("dpTofu.finish", resourceRoot, getElapsedTime(), not isThereCollision)
end

addEvent("dpTofu.finish", true)
addEventHandler("dpTofu.finish", localPlayer,
    function (money, xp, perfectBonus, timeBonus, isPerfect, timePassed)
        FinishScreen.show(money, xp, perfectBonus, timeBonus, timePassed)
        cancelTofu()
    end
)

local function handlePedCollision(colshape, element, matchingDimension, enabled)
    if not matchingDimension then
        return
    end
    if not isElement(element) then
        return
    end

    if element.type == "player" or element.type == "vehicle" then
        local ped
        for i, tofuPoint in ipairs(tofuPoints) do
            if tofuPoint.colshape == colshape then
                ped = tofuPoint.ped
                break
            end
        end
        ped:setCollidableWith(element, enabled)
    end
end

addEvent("dpConfig.update", false)
addEventHandler("dpConfig.update", root, function (key, value)
    -- toggle music
    if key == "game.background_music" then
        if value then
            for i, point in ipairs(TOFU_POINT_POSITIONS) do
                local sound = Sound3D("music/music.mp3", point.music, true)
                sound.minDistance = 20
                sound.maxDistance = 50
                tofuPoints[i].sound = sound
            end
        else
            for i, point in ipairs(tofuPoints) do
                point.sound:destroy()
                point.sound = nil
            end
        end
    end
end)

addEventHandler("onClientColShapeHit", resourceRoot, function (element, matchingDimension)
    handlePedCollision(source, element, matchingDimension, false)
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function (element, matchingDimension)
    handlePedCollision(source, element, matchingDimension, true)
end)

addEventHandler("onClientVehicleCollision", root, function (_, force)
    if not isRunning then
        return
    end
    if source ~= localPlayer.vehicle then
        return
    end
    if force < MIN_COLLISION_FORCE then
        return
    end
    isThereCollision = true
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer,
    function (vehicle, seat)
        if not isRunning then
            return
        end
        cancelTofu()
    end
)
