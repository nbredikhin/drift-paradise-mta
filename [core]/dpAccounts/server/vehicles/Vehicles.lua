Vehicles = {}
local VEHICLES_TABLE_NAME = "vehicles"

function Vehicles.setup()
	DatabaseTable.create(VEHICLES_TABLE_NAME, {
		{ name="owner_id", type=DatabaseTable.ID_COLUMN_TYPE, options="NOT NULL" },
		{ name="model", type="smallint", options="UNSIGNED NOT NULL" },
		{ name="color", type="int", options="UNSIGNED NOT NULL DEFAULT 16755200" },
		{ name="spoiler", type="smallint", options="UNSIGNED NOT NULL DEFAULT 0" },
		{ name="wheels", type="smallint", options="UNSIGNED NOT NULL DEFAULT 0" },
	}, "FOREIGN KEY (owner_id)\n\tREFERENCES users(id)\n\tON DELETE CASCADE", function (result) 
		if not result then
			outputDebugString("Vehicles table already exists")
		end		
	end)
end