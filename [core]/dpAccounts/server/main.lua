addEventHandler("onResourceStart", resourceRoot, function ()
	if not Database.connect() then
		return 
	end
	outputDebugString("Database connection success")

	outputDebugString("Creating users table...")
	Users.setup()
end)