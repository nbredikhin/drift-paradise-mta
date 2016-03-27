addEventHandler("onResourceStart", resourceRoot, function ()
	if not Database.connect() then
		return 
	end
	outputDebugString("Database connection success")
	DatabaseTable.create("users", {
		{name = "name", type="varchar", size=255},
		{name = "password", type="varchar", size=255}
	})
end)