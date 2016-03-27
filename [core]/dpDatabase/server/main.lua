addEventHandler("onResourceStart", resourceRoot, function ()
	if not Database.connect() then
		return 
	end
	outputDebugString("Database connection success")

	DatabaseTable.create("users", {
		{name = "name", type="varchar", size=255, options="UNIQUE"},
		{name = "password", type="varchar", size=255}
	})
	DatabaseTable.insert("users", {name = "user1", password = "12345"})
	DatabaseTable.insert("users", {name = "user2", password = "12345"})

	DatabaseTable.update("users", {name = "user3"}, {name = "userShiet"})
end)