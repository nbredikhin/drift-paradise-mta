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
	Houses.setup()
end)

addEventHandler("onPlayerQuit", root, function ()
	Users.logoutPlayer(source)
end)