local replaceSkins = {
	1, 2, 22
}

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, model in ipairs(replaceSkins) do
		local txd = engineLoadTXD(tostring(i) .. ".txd")
		engineImportTXD(txd, model)
		local dff = engineLoadDFF(tostring(i) .. ".dff")
		engineReplaceModel(dff, model)
	end
end)