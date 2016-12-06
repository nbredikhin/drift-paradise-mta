SERVER_ID = 1
if string.find(getServerName(), "#2", 1, true) then
	SERVER_ID = 2
elseif string.find(getServerName(), "Default") or string.find(getServerName(), "Test") then
	SERVER_ID = 3
end

addEventHandler("onResourceStart", resourceRoot, function ()
	if not Database.connect() then
		outputDebugString("ERROR: Database connection failed")
		return
	end
	BetaKeys.start()

	outputDebugString("Database connection success")
	outputDebugString("Creating and setting up tables...")
	Users.setup()
	UserVehicles.setup()
	GiftKeys.setup()
	Donations.setup()
	outputDebugString("Server started. SERVER_ID=" .. tostring(SERVER_ID))
end)

addEventHandler("onPlayerQuit", root, function ()
	Users.logoutPlayer(source)
end)
