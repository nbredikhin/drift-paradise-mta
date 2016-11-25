addEventHandler("onClientResourceStart", resourceRoot, function ()
	if not fileExists(":dpCacheLock/lock.txt") then
		triggerServerEvent("dpCacheLock.reportMissingCache", resourceRoot)
	end
end)