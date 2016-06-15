local function onPlayerConnect()
	-- Локализация здесь
	outputChatBox("#FF0000SERVER: Client " .. source.name  .. " connected!", 255, 255, 255, true)
end

local function onPlayerQuit(reason)
	outputChatBox("#FF0000SERVER: Client " .. source.name  .. "#FF0000 disconntected. Reason: " .. reason, 255, 255, 255, true)
end

addEventHandler("onClientPlayerJoin", getRootElement(), onPlayerConnect)
addEventHandler("onClientPlayerQuit", getRootElement(), onPlayerQuit)